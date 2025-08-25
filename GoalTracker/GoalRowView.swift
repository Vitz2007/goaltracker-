//
//  GoalRowView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/08.
//

import SwiftUI

struct GoalRowView: View {
    @Binding var goal: Goal
    let settings: AppSettings
    let onCheckIn: () -> Void

    private var category: GoalCategory? {
        GoalLibrary.categories.first { $0.id == goal.categoryID }
    }
    
    private var categoryColor: Color {
        switch category?.colorName {
        case "green": return .green
        case "red": return .red
        case "blue": return .blue
        default: return settings.currentAccentColor
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: goal.iconName ?? category?.iconName ?? "target")
                    .font(.title2)
                    .foregroundStyle(categoryColor)
                    .frame(width: 30)
                
                Text(LocalizedStringKey(goal.title))
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                // CheckInButtonView now just needs a simple closure
                Button(action: onCheckIn) {
                    Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title)
                        .foregroundStyle(goal.isCompleted ? .green : categoryColor)
                }
                .buttonStyle(.plain)
            }
            
            HStack {
                Spacer()
                if let dueDate = goal.dueDate {
                    HStack(spacing: 4) {
                        Text("goalRow.due")
                        Text(dueDate, style: .date)
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
