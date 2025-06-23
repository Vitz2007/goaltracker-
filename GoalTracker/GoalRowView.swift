//
//  GoalRowView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/08.
//

import SwiftUI

struct GoalRowView: View {
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
    }
}
