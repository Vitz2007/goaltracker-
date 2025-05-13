//
//  GoalRowView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/08.
//

import SwiftUI

struct GoalRowView: View {
    // Use @ObservedObject or @State if the goal itself or its properties
    // were directly manipulated here and need to trigger updates *from* here.
    // However, your current setup uses a closure (`onToggleCompletion`)
    // which is a good pattern.
    let goal: Goal
    var onToggleCompletion: () -> Void // Closure to call when the checkmark is tapped

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundColor(goal.isCompleted ? .green : .gray)
                .onTapGesture {
                    onToggleCompletion() // Call the closure
                }
                .frame(width: 48) // Maintain consistent tap area/spacing

            VStack(alignment: .leading) {
                Text(goal.title)
                    .font(.headline)
                if let dueDate = goal.dueDate {
                    Text("Due: \(dueDate, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer() // Pushes content to the left
        }
        .padding(.vertical, 8) // Adjusted padding slightly, was 15, can be whatever you like
    }
}
