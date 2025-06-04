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
    var onUpdate: (Goal) -> Void // This is for saving general goal updates
    var onDelete: (UUID) -> Void
    

    // Animation states
    @Binding var editButtonTapped: Bool
    @Binding var progressButtonTapped: Bool
    @Binding var showingProgressSheet: Bool // Used by ProgressActionButtonView
    @Binding var finishButtonScale: CGFloat
    @Binding var deleteButtonTapped: Bool

    // --- ADD THIS NEW PROPERTY ---
    var onEditButtonTap: () -> Void  // Closure to execute when edit is tapped
    var onFinishButtonTap: () -> Void // For finish action hitting goal button
    // --- END OF NEW PROPERTY ---

    let bottomBarBackgroundColor: Color

    var body: some View {
        HStack {
            EditActionButtonView(isTapped: $editButtonTapped) {
                // This is the 'action' for EditActionButtonView
                print("Edit button tapped inside ActionBottomBarView for \(goal.title)")
                self.editButtonTapped.toggle() // For the bounce animation
                self.onEditButtonTap()         // << CALL THE NEW CLOSURE HERE
            }

            Spacer()

            ProgressActionButtonView(isTapped: $progressButtonTapped) {
                print("Progress tapped for \(goal.title)")
                // This action is specific to showing the progress sheet
                self.progressButtonTapped.toggle() // For animation
                self.showingProgressSheet = true
            }

            Spacer()

            FinishActionButtonView(scale: $finishButtonScale) {
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
                // Call new closure that will implement actual function
                self.onFinishButtonTap() // Calls new closure
            }

            Spacer()

            DeleteActionButtonView(isTapped: $deleteButtonTapped) {
                print("Delete tapped for \(goal.title)")
                self.deleteButtonTapped.toggle() // For animation
                onDelete(goal.id) // Directly call onDelete
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom)
        .frame(maxWidth: .infinity)
        .background(bottomBarBackgroundColor)
    }
}
