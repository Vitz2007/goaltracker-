//
//  GoalDetailView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/17.
//
import SwiftUI

struct GoalDetailView: View {
    @State var goal: Goal
    var onUpdate: (Goal) -> Void
    var onDelete: (UUID) -> Void

    // Animation states
    @State private var editButtonAnimationTrigger = false
    @State private var progressButtonAnimationTrigger = false
    @State private var finishButtonScale: CGFloat = 1.0
    @State private var deleteButtonAnimationTrigger = false
    @State private var showingProgressSheet = false
    @State private var showingEditSheet = false
    @State private var showingAddCheckInNoteSheet = false

    // State for Undo
    @State private var showingUndoCheckInConfirmation = false
    @State private var lastCheckInNote: String? = nil

    let bottomBarBackgroundColor = Color.gray.opacity(0.1)

    var body: some View {
        ZStack {
            ScrollView {
                VStack (spacing: 20) {
                    Text(goal.title)
                        .font(.largeTitle)
                        .strikethrough(goal.isCompleted, color: .primary)
                        .opacity(goal.isCompleted ? 0.6 : 1.0)
                        .padding(.horizontal)
                        .padding(.top)

                    CheckInButtonView(title: goal.title) {
                        if !goal.isCompleted {
                            self.showingAddCheckInNoteSheet = true
                        }
                    }
                    .disabled(goal.isCompleted)

                    Spacer()

                    ActionBottomBarView(
                        goal: $goal,
                        onUpdate: onUpdate,
                        onDelete: onDelete,
                        editButtonTapped: $editButtonAnimationTrigger,
                        progressButtonTapped: $progressButtonAnimationTrigger,
                        showingProgressSheet: $showingProgressSheet,
                        finishButtonScale: $finishButtonScale,
                        deleteButtonTapped: $deleteButtonAnimationTrigger,
                        onEditButtonTap: {
                            if !goal.isCompleted {
                                self.showingEditSheet = true
                            }
                        },
                        onFinishButtonTap: {
                            if !goal.isCompleted {
                                self.goal.isCompleted = true
                                self.goal.completionPercentage = 1.0
                                self.onUpdate(self.goal)
                            }
                        },
                        bottomBarBackgroundColor: bottomBarBackgroundColor
                    )
                }
            }

            // Pop-up view logic
            if showingUndoCheckInConfirmation {
                VStack {
                    Spacer()

                    // --- FIX WAS HERE ---
                    // Move modifiers to the View, not the VStack.
                    UndoCheckInConfirmationView(
                        message: lastCheckInNote == nil ? "Checked in!" : "Checked in with note.",
                        onUndo: {
                            _ = goal.checkIns.popLast()

                            if goal.targetCheckIns > 0 {
                                let calculatedPercentage = Double(goal.checkIns.count) / Double(goal.targetCheckIns)
                                goal.completionPercentage = min(1.0, max(0.0, calculatedPercentage))
                            } else {
                                goal.completionPercentage = 0
                            }
                            
                            onUpdate(goal)
                            self.showingUndoCheckInConfirmation = false
                        },
                        onDismiss: {
                            self.showingUndoCheckInConfirmation = false
                        }
                    )
                    .padding(.horizontal) // Better padding
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.easeInOut, value: showingUndoCheckInConfirmation)
            }
        }
        .navigationTitle("Goal Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingProgressSheet) {
            ActivityLogView(goal: self.goal)
        }
        .sheet(isPresented: $showingEditSheet) {
            EditGoalView(goalToEdit: self.goal) { updatedGoalFromEditView in
                self.goal = updatedGoalFromEditView
                self.onUpdate(updatedGoalFromEditView)
            }
        }
        .sheet(isPresented: $showingAddCheckInNoteSheet) {
            AddCheckInNoteView { noteText_from_sheet in
                let newCheckIn = CheckInRecord(date: Date(), note: noteText_from_sheet)
                goal.checkIns.append(newCheckIn)

                if goal.targetCheckIns > 0 {
                    let calculatedPercentage = Double(goal.checkIns.count) / Double(goal.targetCheckIns)
                    goal.completionPercentage = min(1.0, max(0.0, calculatedPercentage))
                }
                
                if goal.checkIns.count >= goal.targetCheckIns {
                    goal.completionPercentage = 1.0
                }

                onUpdate(goal)
                
                self.lastCheckInNote = noteText_from_sheet
                self.showingUndoCheckInConfirmation = true
            }
        }
        .onChange(of: showingUndoCheckInConfirmation) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    if self.showingUndoCheckInConfirmation {
                        withAnimation {
                            self.showingUndoCheckInConfirmation = false
                        }
                    }
                }
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
