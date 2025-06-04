//
//  EmptyStateView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/08.
//
import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) { // Wrap in VStack to allow Spacer() to work
            Spacer() // Pushes content towards center if VStack fills space
            Image(systemName: "sparkles")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing
                )
            )
                .padding(.bottom, 10)
                .offset(y: -20)
                .foregroundColor(.secondary)
                .padding(.bottom, 10) // Space below icon
            
            Text("No Goals Yet?")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the '+' button below to add your first goal and start tracking your progress.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center) // For longer text
                .padding(.horizontal, 40) // Prevents from text being too long/wide
            
            Spacer() // Pushes content towards the center
        }
        // Ensure VStack tries to take up space if available by its parent
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView()
            .padding() // Add some possible padding?
    }
}
