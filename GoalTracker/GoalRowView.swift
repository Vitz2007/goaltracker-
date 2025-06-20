//
//  GoalRowView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/08.
//

import SwiftUI

struct GoalRowView: View {
    @Binding var goal: Goal // Use @Binding if modify goal directly (ie: toggle completion)
        // OR pass simple goal and a closure for actions
    var onToggleCompletion: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundColor(goal.isCompleted ? .green : .gray)
                .onTapGesture {
                    onToggleCompletion()
                }
                .frame(width: 48) // Keep touch target reasonable/simple

            VStack(alignment: .leading, spacing: 4) { // adding spacing for balance
                
                HStack {
                    Text(goal.title)
                        .font(.headline)
                        .strikethrough(goal.isCompleted, color: .primary)
                    
                    Spacer() // Pushes the badge to the right in this row
                    
                    // Show streak badge if the streak is 2 or more
                    // and goal is not yet completed.
                    if goal.currentStreak > 1 && !goal.isCompleted {
                        StreakBadgeView(streakCount: goal.currentStreak)
                    }
                }
                
                // Assuming Goal struct has an optional dueDate = LEAVE
                if let dueDate = goal.dueDate {
                    Text("Due: \(dueDate, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8) // Adjust padding if need be, original was 15
    }
}
