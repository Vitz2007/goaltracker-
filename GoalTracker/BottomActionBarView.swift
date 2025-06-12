//
//  BottomActionBarView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//

// In BottomActionBarView.swift
import SwiftUI

struct ActionBottomBarView: View {
    @Binding var goal: Goal
    // Add new closures for clarity
    var onEditButtonTap: () -> Void
    var onFinishButtonTap: () -> Void
    var onDeleteButton: () -> Void // New one for the delete button
    

    // Animation states
    @Binding var editButtonTapped: Bool
    @Binding var progressButtonTapped: Bool
    @Binding var showingProgressSheet: Bool // Used by ProgressActionButtonView
    @Binding var finishButtonScale: CGFloat
    @Binding var deleteButtonTapped: Bool


    let bottomBarBackgroundColor: Color

    var body: some View {
        HStack {
            EditActionButtonView(isTapped: $editButtonTapped) {
                // The 'action' for EditActionButtonView
                print("Edit button tapped inside ActionBottomBarView for \(goal.title)")
                self.editButtonTapped.toggle() // For the bounce animation
                self.onEditButtonTap()         // << Calling the new closure
            }

            Spacer()

            ProgressActionButtonView(isTapped: $progressButtonTapped) {
                print("Progress tapped for \(goal.title)")
                // This action shows the progress sheet
                self.progressButtonTapped.toggle() // For animation
                self.showingProgressSheet = true
            }

            Spacer()

            FinishActionButtonView(
                isCompleted: goal.isCompleted,
                scale: $finishButtonScale
            ) {
                print("Finish button tapped (animation part) for \(goal.title)")
                // Existing finish button animation and action logic
                 withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                     finishButtonScale = 1.2 // Scale up
                 }
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                     withAnimation(.spring()) {
                         finishButtonScale = 1.0 // Scale back
                     }
                 }
                // Call the new closure that will implement actual function
                self.onFinishButtonTap() // Calls new closure
            }

            Spacer()

            DeleteActionButtonView(isTapped: $deleteButtonTapped) {
                print("Delete button tapped, requesting confirmation from parent view...")
                self.deleteButtonTapped.toggle() // For animation
                self.onDeleteButton() // Calling the new closure for delete here
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom)
        .frame(maxWidth: .infinity)
        .background(bottomBarBackgroundColor)
    }
}
