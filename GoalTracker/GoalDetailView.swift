//
//  GoalDetailView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/17.
//
import SwiftUI

struct GoalDetailView: View {
    @State var goal: Goal // The goal being viewed and possibly modified
    var onUpdate: (Goal) -> Void
    var onDelete: (UUID) -> Void

    // Animation states
    @State private var editButtonAnimationTrigger = false
    @State private var progressButtonAnimationTrigger = false
    @State private var finishButtonScale: CGFloat = 1.0
    @State private var deleteButtonAnimationTrigger = false
    @State private var showingProgressSheet = false
    @State private var showingEditSheet = false
    
    // Add new STATE Variable for check-in note sheet
    @State private var showingAddCheckInNoteSheet = false

    let bottomBarBackgroundColor = Color.gray.opacity(0.1)

    var body: some View {
        VStack (spacing: 20) {
            Text(goal.title)
                .font(.largeTitle)
                .strikethrough(goal.isCompleted, color: .primary) // UI Change for completed state
                .opacity(goal.isCompleted ? 0.6 : 1.0)          // UI change for completed state
                .padding(.horizontal)
                .padding(.top)

            CheckInButtonView(title: goal.title) {
                            if !goal.isCompleted {
                                // Show the note sheet instead of creating CheckInRecord automatically
                                self.showingAddCheckInNoteSheet = true
                            }
                        }
                        .disabled(goal.isCompleted)

            Spacer()

            ActionBottomBarView(
                goal: $goal,
                onUpdate: onUpdate, // For general goal updates (ie: check-ins)
                onDelete: onDelete,
                editButtonTapped: $editButtonAnimationTrigger,
                progressButtonTapped: $progressButtonAnimationTrigger,
                showingProgressSheet: $showingProgressSheet,
                finishButtonScale: $finishButtonScale,
                deleteButtonTapped: $deleteButtonAnimationTrigger,
                onEditButtonTap: {
                    // Only allow edit if goal is not completed (optional rule)
                    if !goal.isCompleted {
                        self.showingEditSheet = true
                    }
                },
                onFinishButtonTap: {
                    if !goal.isCompleted { // Only complete if not already completed
                        print("Completing goal: \(goal.title)")
                        // Modify the @State variable directly
                        // so SwiftUI understands to re-render dependent views.
                        self.goal.isCompleted = true
                        self.goal.completionPercentage = 1.0
                        // If we add completionDate to Goal model:
                        // self.goal.completionDate = Date()
                        
                        // Calls the onUpdate closure passed from ContentView
                        // to update the main goals array and persist changes.
                        self.onUpdate(self.goal)
                        print("Goal '\(self.goal.title)' marked as completed!")
                    }
                    // Optionally, we could implement "un-completing" logic here
                    // if the button were to toggle completion.
                },
                bottomBarBackgroundColor: bottomBarBackgroundColor
            ) // Closing parenthesis for ActionBottomBarView call
            // Can disable the whole bar or parts of it based on goal.isCompleted
            // For example:
            // .disabled(goal.isCompleted)

        } // Closing brace for main VStack
        .navigationTitle("Goal Details") // Or "" if removed this earlier
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingProgressSheet) { // Sheet for GoalProgressView
            GoalProgressView(goal: self.goal)
        } // Closing brace for the first .sheet modifier
        .sheet(isPresented: $showingEditSheet) { // Sheet for EditGoalView
            // Make sure EditGoalView initializer is `init(goalToEdit: Goal, onSave: @escaping (Goal) -> Void)`
            // or adjust this call properly.
            EditGoalView(goalToEdit: self.goal) { updatedGoalFromEditView in
                // This is for the onSave closure from EditGoalView
                self.goal = updatedGoalFromEditView
                self.onUpdate(updatedGoalFromEditView)
            }
        } // Closing brace for the second .sheet modifier
        .sheet(isPresented: $showingAddCheckInNoteSheet) {
                    AddCheckInNoteView { noteText_from_sheet in
                        // This closure is called when AddCheckInNoteView calls onComplete
                        // 'noteText' will be the String? containing the note.
                        print(">>>>>> GOALDETAILVIEW: AddCheckInNoteView SHEET DISMISSED & onComplete CALLED! Note: '\(noteText_from_sheet ?? "NO NOTE PASSED")' <<<<<<")
                        
                        // Created the CheckInRecord with the (optional) note
                        let newCheckIn = CheckInRecord(date: Date(), note: noteText_from_sheet)
                        // Adding debug print for note to print
                        print("DEBUG GoalDetailView: Creating CheckInRecord - Date: \(newCheckIn.note ?? "NIL")")
                        goal.checkIns.append(newCheckIn)

                        // Recalculate completionPercentage
                        if goal.targetCheckIns > 0 {
                            let calculatedPercentage = Double(goal.checkIns.count) / Double(goal.targetCheckIns)
                            goal.completionPercentage = min(1.0, max(0.0, calculatedPercentage))
                        }
                        
                        if goal.checkIns.count >= goal.targetCheckIns {
                            goal.completionPercentage = 1.0
                            // Optionally auto-complete:
                            // if !goal.isCompleted { goal.isCompleted = true }
                        }

                        onUpdate(goal) // Update the main list and save
                        print("Checked in for '\(goal.title)' with note: '\(noteText_from_sheet ?? "N/A")'. Total: \(goal.checkIns.count). Progress: \(goal.completionPercentage * 100)%")
                    }
                }
    } // Closing brace for var body: some View
} // Closing brace for struct GoalDetailView: View
// Simple Shake Effect Modifier -
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

// Previews
struct GoalDetailView_Previews: PreviewProvider {
    // Using a wrapper to manage @State for the preview
    struct PreviewWrapper: View {
        @State var sampleGoal = Goal(title: "Sample Preview Goal", dueDate: Date(), isCompleted: false, checkIns: [])

        var body: some View {
            NavigationView {
                GoalDetailView(
                    goal: sampleGoal, // Pass the @State variable
                    onUpdate: { updatedGoalFromPreview in
                        self.sampleGoal = updatedGoalFromPreview // Update the state
                        print("Preview: Goal updated to: \(updatedGoalFromPreview.title)")
                    },
                    onDelete: { goalIdFromPreview in
                        print("Preview: Delete goal with ID: \(goalIdFromPreview)")
                    }
                )
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
