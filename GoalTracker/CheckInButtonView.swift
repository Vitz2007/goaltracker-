//
//  CheckInButtonView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//

import SwiftUI

struct CheckInButtonView: View {
    
    // This defines properties that GoalRowView is trying to pass in
    let isCompleted: Bool
    let color: Color
    let onTap: (CGPoint) -> Void

    var body: some View {
        // Use GeometryReader to find the button's global position for confetti
        GeometryReader { proxy in
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title)
                .foregroundStyle(isCompleted ? .green : color) // Using modern .foregroundStyle here
                .onTapGesture {
                    // When tapped, pass the center position of the button to the action
                    let frame = proxy.frame(in: .global)
                    let center = CGPoint(x: frame.midX, y: frame.midY)
                    onTap(center)
                }
                .accessibilityLabel(isCompleted ? "checkinButton.accessibility.incomplete" : "checkinButton.accessibility.complete")
        }
        .frame(width: 30, height: 30) // Give the button a consistent size
    }
}

// Adding a preview to see the button in isolation if you like
struct CheckInButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 20) {
            CheckInButtonView(isCompleted: false, color: .blue) { _ in
                print("Tapped incomplete button")
            }
            CheckInButtonView(isCompleted: true, color: .blue) { _ in
                print("Tapped complete button")
            }
        }
        .padding()
    }
}
