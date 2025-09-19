//
//  AppSettings.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/23.
//

import SwiftUI

// A simple struct to hold the data for a color choice
struct ColorChoice: Identifiable {
    let id: String
    let name: String
    let color: Color
}

// A class to manage the app's settings, like the accent color and streaks.
class AppSettings: ObservableObject {
    // Shared instance for easy access across the app
    static let shared = AppSettings()
    
    // --- Theme Color Feature ---
    let colorOptions: [ColorChoice] = [
        ColorChoice(id: "default", name: "color.defaultBlue", color: .blue), // Use the asset catalog color
        ColorChoice(id: "green", name: "color.green", color: .green),
        ColorChoice(id: "red", name: "color.red", color: .red),
        ColorChoice(id: "purple", name: "color.purple", color: .purple),
        ColorChoice(id: "orange", name: "color.orange", color: .orange)
    ]
    
    @Published var selectedColorId: String {
        didSet {
            UserDefaults.standard.set(selectedColorId, forKey: "accentColorId")
        }
    }
    
    var currentAccentColor: Color {
        (colorOptions.first(where: { $0.id == selectedColorId }) ?? colorOptions.first)!.color
    }

    func themeColor(for colorName: String) -> Color {
        switch colorName {
        case "green":
            return .green
        case "red":
            return .red
        case "blue":
            return .blue
        default:
            // Fall back to the user's currently selected accent color
            return self.currentAccentColor
        }
    }

    // --- Streak Toggle Feature (Merged and fixed) ---
    @Published var streaksEnabled: Bool {
        didSet {
            // Fixed typo: was "streakEnabled"
            UserDefaults.standard.set(streaksEnabled, forKey: "streaksEnabled")
        }
    }

    // When the class is initialized, load all saved settings.
    private init() {
        // Load selected color ID, defaulting to "default"
        self.selectedColorId = UserDefaults.standard.string(forKey: "accentColorId") ?? "default"
        
        // Load streaksEnabled setting, defaulting to true if not set
        if UserDefaults.standard.object(forKey: "streaksEnabled") == nil {
            self.streaksEnabled = true // Set an initial default
        } else {
            self.streaksEnabled = UserDefaults.standard.bool(forKey: "streaksEnabled")
        }
    }
}
