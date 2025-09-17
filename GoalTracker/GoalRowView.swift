//
//  GoalRowView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/08.
//

import SwiftUI

struct GoalRowView: View {
<<<<<<< HEAD
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
=======
    @Binding var goal: Goal
    // Receive Appsettings object
    let settings: AppSettings
    var onToggleCompletion: () -> Void

    // New state to control halo's animation
    @State private var showHalo: Bool = false
    @State private var triggerComebackAnimation: Bool = false

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundColor(goal.isCompleted ? .green : .secondary) // Use .secondary for a more standard look
                
                // Visual effect for the halo
                .background(
                    // A circle that actd as our glow
                    Circle()
                        .fill(Color.teal.opacity(showHalo && settings.streaksEnabled ? 0.38 : 0)) // The halo is visible only when showHalo is true
                        .blur(radius: 10)
                        .scaleEffect(showHalo && settings.streaksEnabled ? (triggerComebackAnimation ? 4.0 : 1.3) : 1) // Apply animation effects
                )

                .onTapGesture {
                    onToggleCompletion()
                }
                .frame(width: 48)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(goal.title)
                        .font(.headline)
                        .strikethrough(goal.isCompleted, color: .primary)
                    
                }
                
                if let dueDate = goal.dueDate {
                    Text("Due: \(dueDate, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
        
        // Important modifier monitors the haloState and controls the UI
        .onChange(of: goal.haloState) { oldValue, newValue in
            // Using a switch to handle each state clearly
            switch newValue {
            case .none:
                // If no streak, hide the halo
                withAnimation(.easeOut(duration: 0.5)) {
                    showHalo = false
                }
            case .active:
                // If streak is active, show halo (without the big pulse).
                withAnimation(.easeIn) {
                    showHalo = true
                }
                triggerComebackAnimation = false
            case .earned:
                // Special "comeback" state.
                showHalo = true
                // Trigger the big pulse animation
                withAnimation(.spring(response: 0.4, dampingFraction: 0.4)) {
                    triggerComebackAnimation = true
                }
                // After animation, reset the trigger so it can happen again later
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        triggerComebackAnimation = false
                    }
                }
            }
        }
        // Makes sure the halo state is correct when the view first appears
        .onAppear {
            switch goal.haloState {
            case .none:
                showHalo = false
            case .active, .earned:
                showHalo = true
            }
        }
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
    }
}
