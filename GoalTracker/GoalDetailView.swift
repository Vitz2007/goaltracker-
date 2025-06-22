//
//  GoalDetailView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/17.
//
//
//  GoalDetailView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/17.
//
import SwiftUI

struct GoalDetailView: View {
    
    @Binding var goal: Goal
    var onDelete: (UUID) -> Void
    @State private var showingDeleteAlert = false

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
    
    // Reworked body with ZStack
    var body: some View {
        ZStack {
            // Main content layer with a VStack for vertical layout
            VStack(spacing: 0) {
                
                // Scrollable content
                ScrollView {
                    VStack(spacing: 20) {
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
                        
                        // New chart section
                        VStack {
                            Divider()
                            Text("Last 7 Days Activity")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            
                            ActivityBarChartView(activityData: goal.recentActivity)
                                .padding(.horizontal)
                        }
                        .padding(.top)
                        
                    } // End of inner VStack for scrollable content
                    .padding(.bottom)
                } // End of ScrollView
                
                // Fixed bottom bar from moving up, outside the ScrollView
                ActionBottomBarView(
                    goal: $goal,
                    onEditButtonTap: {
                        if !goal.isCompleted {
                            self.showingEditSheet = true
                        }
                    },
                    onFinishButtonTap: {
                        // This handles both completing and un-completing the goal
                        goal.isCompleted.toggle()

                        // This logic later updates the progress percentage accordingly
                        if goal.isCompleted {
                            // If goal is now "Finished", set progress to 100%
                            goal.completionPercentage = 1.0
                        } else {
                            // If goal is now "Re-opened", recalculate the true progress.
                            if goal.targetCheckIns > 0 {
                                let calculatedPercentage = Double(goal.checkIns.count) / Double(goal.targetCheckIns)
                                goal.completionPercentage = min(1.0, max(0.0, calculatedPercentage))
                            } else {
                                goal.completionPercentage = 0
                            }
                        }
                    },
                    // Tapping delete button in the bar triggers state variable to 'true'
                    onDeleteButton: {
                        self.showingDeleteAlert = true
                    },
                    editButtonTapped: $editButtonAnimationTrigger,
                    progressButtonTapped: $progressButtonAnimationTrigger,
                    showingProgressSheet: $showingProgressSheet,
                    finishButtonScale: $finishButtonScale,
                    deleteButtonTapped: $deleteButtonAnimationTrigger,
                    bottomBarBackgroundColor: bottomBarBackgroundColor
                )
                
            } // End of main VStack

            // Pop-up View Layer
            if showingUndoCheckInConfirmation {
                VStack {
                    Spacer()
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
                        },
                        onDismiss: {
                            self.showingUndoCheckInConfirmation = false
                        }
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.easeInOut, value: showingUndoCheckInConfirmation)
            }
        } // End of ZStack
        .navigationTitle("Goal Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingProgressSheet) {
            ActivityLogView(goal: self.goal)
        }
        .sheet(isPresented: $showingEditSheet) {
            // Passing a direct binding to the goal
            EditGoalView(goal: $goal)
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
        // Add alert modifier for delete goal
        .alert("Delete Goal?", isPresented: $showingDeleteAlert) {
            // The destructive button. This is where the actual delete happens.
            Button("Delete", role: .destructive) {
                onDelete(goal.id) // Call the original onDelete closure
            }
            
            // The cancel button does nothing, just dismisses the alert.
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this goal? This action cannot be undone.")
        }
    } // Closing brace for var body
    
} // Closing brace for struct GoalDetailView


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
        @State var sampleGoal = Goal(
            title: "Sample Preview Goal",
            startDate: Date(),
            dueDate: Date(),
            isCompleted: false,
            checkIns: [],
            targetCheckIns: 10,
            reminderIsEnabled: false,
            reminderDate: Date()
        )
        
        var body: some View {
            NavigationView {
                GoalDetailView(
                    goal: $sampleGoal,
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
