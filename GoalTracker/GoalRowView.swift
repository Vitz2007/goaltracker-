//
//  GoalRowView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/08.
//

import SwiftUI

struct GoalRowView: View {
    let goal: Goal
    let settings: AppSettings
    let onCheckIn: (CGPoint) -> Void

    private var category: GoalCategory? {
        GoalLibrary.categories.first { $0.id == goal.categoryID }
    }
    
    private var categoryColor: Color {
        settings.themeColor(for: category?.colorName ?? "")
    }
    
    private var iconNameToDisplay: String {
        if let iconName = goal.iconName, !iconName.isEmpty {
            return iconName
        }
        if let iconName = category?.iconName, !iconName.isEmpty {
            return iconName
        }
        return "target"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: iconNameToDisplay)
                    .font(.title2)
                    .foregroundStyle(categoryColor)
                    .frame(width: 30)
                
                if goal.title.contains("category.") {
                    Text(LocalizedStringKey(goal.title))
                        .font(.headline)
                        .fontWeight(.bold)
                } else {
                    Text(goal.title)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                GeometryReader { proxy in
                    Button(action: {
                        let frame = proxy.frame(in: .global)
                        let center = CGPoint(x: frame.midX, y: frame.midY)
                        onCheckIn(center)
                    }) {
                        Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title)
                            .foregroundStyle(goal.isCompleted ? .green : categoryColor)
                    }
                    .buttonStyle(.plain)
                }
                .frame(width: 30, height: 30)
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
