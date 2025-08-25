//
//  OnboardingWelcomeView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/10.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // A visual element. We can make this a custom animation later.
            Image(systemName: "leaf.arrow.triangle.circlepath")
                .font(.system(size: 120))
                .foregroundStyle(Color.green.gradient)
            
            // The benefit-oriented text from our plan.
            Text("onboarding.welcome.title")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("onboarding.welome.subtitle")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            Spacer()
        }
        .padding(30)
    }
}

#Preview {
    OnboardingWelcomeView()
}
