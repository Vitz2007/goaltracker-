//
//  ActionButtonView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//

import SwiftUI

// New struct for edit button
struct EditActionButtonView: View {
    @Binding var isTapped: Bool // For animation
    let action: () -> Void     // << For 'action' property

    var body: some View {
        Button {
            action() // << Call the passed-in action
            // May want to toggle 'isTapped' for animation,
            // or handle animation based on the sheet's presentation.
        } label: {
            Image(systemName: "pencil.line")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.blue.opacity(0.7))
                .cornerRadius(8)
                .symbolEffect(.bounce, value: isTapped) // isTapped needs to be toggled if used for animation
        }
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
                .background(Color.orange.opacity(0.7)) // Orange button
                .cornerRadius(8)
                .symbolEffect(.pulse, value: isTapped)
        }
    }
}

// New struct for finish action button
// This code goes at the bottom of your BottomActionBarView.swift file,
// replacing the old FinishActionButtonView struct.

import SwiftUI

struct FinishActionButtonView: View {
    // This new property checks the goal's status
    var isCompleted: Bool

    @Binding var scale: CGFloat
    let action: () -> Void
    
    // Easy access to adjusting icon size
    // private let iconSize: CGFloat = 55.5

    var body: some View {
        Button(action: action) {
            // This 'if' statement dynamically changes the button's appearance
            if isCompleted {
                // Re-open icon
                    Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                    .font(.system(size: 65))
                        .foregroundColor(.teal)
                
            } else {
                // The "Finish" icon
                    Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 59.5))
                        .foregroundColor(.green)
                }
            }
        .scaleEffect(scale)
    }
}

// New struct for delete button
struct DeleteActionButtonView: View {
    @Binding var isTapped: Bool // For ShakeEffect
    let action: () -> Void

    var body: some View {
        Button {
            action()
            isTapped.toggle() // This triggers the shake if modifier depends on it
        } label: {
            Image(systemName: "trash")
                .font(.system(size: 27))
                .foregroundColor(.white)
                .padding()
                .background(Color.gray.opacity(0.8)) // Gray button bg
                .cornerRadius(8)
                .modifier(ShakeEffect(animatableData: isTapped ? 1 : 0))
        }
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
    }
}
