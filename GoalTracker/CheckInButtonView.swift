//
//  CheckInButtonView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//
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
    }
}
