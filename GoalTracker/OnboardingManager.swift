//
//  OnboardingManager.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/10.
//

import Foundation
import SwiftUI

// This class will check if the user has completed the onboarding process.
@Observable
class OnboardingManager {
    
    // The key we will use to save the flag in UserDefaults.
    private let onboardingCompletedKey = "hasCompletedOnboarding"
    
    // A property that our views can watch for changes.
    var hasCompletedOnboarding: Bool
    
    init() {
        // When the manager is created, check UserDefaults to see if the flag is already set to true.
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingCompletedKey)
    }
    
    // This function will be called when the user finishes the onboarding flow.
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingCompletedKey)
    }
}
