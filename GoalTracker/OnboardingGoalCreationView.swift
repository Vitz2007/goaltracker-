//
//  OnboardingGoalCreationView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/11.
//

import SwiftUI

struct OnboardingGoalCreationView: View {
    // 1. This is now a @Binding. It receives its value from the parent view.
    @Binding var goalTitle: String

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("onboarding.goalCreation.title")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // 2. The TextField is now connected to the binding.
            TextField("onboarding.goalCreation.placeholder", text: $goalTitle)
                .font(.title2)
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accentColor, lineWidth: goalTitle.isEmpty ? 0 : 2)
                )
            
            Text("onboarding.goalCreation.subtitle")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            Spacer()
            Spacer()
        }
        .padding(30)
    }
}

#Preview {
    // The preview needs a @State variable to provide a binding.
    struct PreviewWrapper: View {
        @State private var title: String = ""
        var body: some View {
            OnboardingGoalCreationView(goalTitle: $title)
        }
    }
    return PreviewWrapper()
}

