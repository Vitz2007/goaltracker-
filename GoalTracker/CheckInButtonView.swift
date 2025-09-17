//
//  CheckInButtonView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//
<<<<<<< HEAD

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
            accessibilityLabel(isCompleted ? "checkinButton.accessibility.incomplete" : "checkinButton.accessibility.complete")
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
=======
import SwiftUI

// New struct crated to fix compiling issues
struct CheckInButtonView: View {
    let title: String // For use in print statement
    let action: () -> Void
    
    var body: some View {
        Button {
            print("Check-in tapped for \(title)")
            
            // Add haptic feedback
            let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
            hapticFeedback.prepare()
            hapticFeedback.impactOccurred()
            
            action() // Call for provided action
        } label: {
            HStack { // HStack for icon and text
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 58, weight: .medium))
                    .foregroundColor(.green)
                    .padding(10)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 4.5)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.top, 26)
        }
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
    }
}
