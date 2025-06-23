//
//  AppSettings.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/23.
//

// In AppSettings.swift
import SwiftUI

// Adding ObservableObject lets our views automatically update when a setting changes
@Observable
class AppSettings {
    // Giving it a value of true and key for "streaksEnabled"
    var streaksEnabled: Bool = UserDefaults.standard.bool(forKey: "streaksEnabled") {
        didSet {
            UserDefaults.standard.set(streaksEnabled, forKey: "streakEnabled")
        }
    }
    
    // Create a single, shared instance for whole app to use
    static let shared = AppSettings()
    
    // Make initializer private so no one else can create another instance
    private init() {
        // Fix for potential issue when default value isn't set on first launch
        if UserDefaults.standard.object(forKey: "streaksEnabled") == nil {
            
        }
    }
}
