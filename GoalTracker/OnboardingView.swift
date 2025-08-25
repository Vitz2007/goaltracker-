//
//  OnboardingView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/10.
//

import SwiftUI

struct OnboardingView: View {
    var manager: OnboardingManager
    // This view now calls a closure with the goal title when it's finished
    var onFinish: (String) -> Void
    
    @State private var tabSelection = 0
    @State private var onboardingGoalTitle: String = ""
    
    let pageCount = 3

    var body: some View {
        VStack {
            TabView(selection: $tabSelection) {
                OnboardingWelcomeView().tag(0)
                OnboardingGoalCreationView(goalTitle: $onboardingGoalTitle).tag(1)
                
                VStack(spacing: 20) {
                    Text("onboarding.final.title")
                        .font(.largeTitle.bold())
                    Text("onboarding.final.subtitle")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("onboarding.final.startButton") {
                        // Pass the title back and let the manager complete
                        onFinish(onboardingGoalTitle)
                        manager.completeOnboarding()
                    }
                    .font(.headline)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.accentColor, in: Capsule())
                    .foregroundStyle(.white)
                    .padding(.top)
                }
                .padding(30)
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Your Custom Page Indicator remains the same
            HStack(spacing: 8) {
                ForEach(0..<pageCount, id: \.self) { index in
                    Capsule()
                        .fill(tabSelection == index ? Color.accentColor : Color.gray.opacity(0.5))
                        .frame(width: tabSelection == index ? 24 : 8, height: 8)
                        .animation(.spring(), value: tabSelection)
                        .onTapGesture { tabSelection = index }
                }
            }
            
            Button("common.skip") {
                // If skipping, pass an empty title back
                onFinish("")
                manager.completeOnboarding()
            }
            .padding()
            .tint(.secondary)
        }
    }
}


#Preview {
    // onFinish can be an empty closure for the preview
    OnboardingView(manager: OnboardingManager(), onFinish: { _ in })
}
