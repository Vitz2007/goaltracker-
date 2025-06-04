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
struct FinishActionButtonView: View {
    @Binding var scale: CGFloat // For scaleEffect
    let action: () -> Void

    var body: some View {
        Button {
            action()
            // Animation handled in the action closure passed from the parent
        } label: {
            Image(systemName: "checkmark.seal")
                .font(.system(size: 27))
                .foregroundColor(.white)
                .padding()
                .background(Color.green.opacity(0.6)) // Green button bg
                .cornerRadius(8)
                .scaleEffect(scale)
        }
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
