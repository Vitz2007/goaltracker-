//
//  ActionButtonView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//

import SwiftUI
import Charts // For chart framework

// New struct for edit button
struct EditActionButtonView: View {
    @Binding var isTapped: Bool // For animation
    let action: () -> Void      // For 'action' property

    var body: some View {
        Button {
            action() // Call the passed-in action
        } label: {
            Image(systemName: "pencil.line")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.blue.opacity(0.7))
                .cornerRadius(8)
                .symbolEffect(.bounce, value: isTapped)
        }
        .accessibilityLabel("accessibility.editButton.label") // ✅ ACCESSIBILITY
    }
}

// New struct for progress button
struct ProgressActionButtonView: View {
    @Binding var isTapped: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
            isTapped.toggle()
        } label: {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 32))
                .foregroundColor(.white)
                .padding()
                .background(Color.orange.opacity(0.7))
                .cornerRadius(8)
                .symbolEffect(.pulse, value: isTapped)
        }
        .accessibilityLabel("accessibility.progressButton.label") // ✅ ACCESSIBILITY
    }
}

// New struct for finish action button
struct FinishActionButtonView: View {
    var isCompleted: Bool
    @Binding var scale: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if isCompleted {
                Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                    .font(.system(size: 65))
                    .foregroundColor(.teal)
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 59.5))
                    .foregroundColor(.green)
            }
        }
        .scaleEffect(scale)
        // ✅ ACCESSIBILITY (Changes based on state)
        .accessibilityLabel(isCompleted ? "accessibility.markIncomplete.label" : "accessibility.markComplete.label")
    }
}

// New struct for delete button
struct DeleteActionButtonView: View {
    @Binding var isTapped: Bool // For ShakeEffect
    let action: () -> Void

    var body: some View {
        Button {
            action()
            isTapped.toggle() // Triggers the shake if modifier depends on it
        } label: {
            Image(systemName: "trash")
                .font(.system(size: 27))
                .foregroundColor(.white)
                .padding()
                .background(Color.gray.opacity(0.8)) // Gray button
                .cornerRadius(8)
        }
        .accessibilityLabel("accessibility.deleteButton.label") // ✅ ACCESSIBILITY
    }
}

// New struct for streak badges
struct StreakBadgeView: View {
    let streakCount: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
            Text("\(streakCount)")
        }
        .font(.caption.weight(.bold))
        .foregroundColor(.orange)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.orange.opacity(0.2))
        .clipShape(Capsule())
        // ✅ ACCESSIBILITY (Combines the label and value for VoiceOver)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("accessibility.streak.label")
    }
}
