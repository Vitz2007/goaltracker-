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
    let onToggleCompletion: (CGPoint) -> Void

    // State to control halo's animation
    @State private var showHalo: Bool = false
    @State private var triggerComebackAnimation: Bool = false

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
                
                Text(goal.title.contains("category.") ? LocalizedStringKey(goal.title) : LocalizedStringKey(goal.title))
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                GeometryReader { proxy in
                    Button(action: {
                        let frame = proxy.frame(in: .global)
                        let center = CGPoint(x: frame.midX, y: frame.midY)
                        onToggleCompletion(center)
                    }) {
                        Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title)
                            .foregroundStyle(goal.isCompleted ? .green : categoryColor)
                            .background(
                                // Visual effect for the halo
                                Circle()
                                    .fill(Color.teal.opacity(showHalo && settings.streaksEnabled ? 0.38 : 0))
                                    .blur(radius: 10)
                                    .scaleEffect(showHalo && settings.streaksEnabled ? (triggerComebackAnimation ? 4.0 : 1.3) : 1)
                            )
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
        // ✅ FIXED: Watch the source of the change (checkIns) instead of the computed property.
        .onChange(of: goal.checkIns) {
            // Re-evaluate the haloState when checkIns change.
            updateHalo(for: goal.haloState)
        }
        .onAppear {
            // Makes sure the halo state is correct when the view first appears
            updateHalo(for: goal.haloState)
        }
    }
    
    // ✅ ADDED: Helper function to avoid repeating code.
    private func updateHalo(for state: HaloState) {
        switch state {
        case .none:
            withAnimation(.easeOut(duration: 0.5)) { showHalo = false }
        case .active:
            withAnimation(.easeIn) { showHalo = true }
            triggerComebackAnimation = false
        case .earned:
            showHalo = true
            withAnimation(.spring(response: 0.4, dampingFraction: 0.4)) {
                triggerComebackAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { triggerComebackAnimation = false }
            }
        }
    }
}
