//
//  AppSettings.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/23.
//

// In AppSettings.swift

import SwiftUI

// A simple struct to hold the data for a color choice
struct ColorChoice: Identifiable {
    let id: String
    let name: String
    let color: Color
}

// A class to manage the app's settings, like the accent color.
class AppSettings: ObservableObject {
    // Shared instance for easy access across the app
    static let shared = AppSettings()
    
    let colorOptions: [ColorChoice] = [
        ColorChoice(id: "default", name: "color.defaultBlue", color: Color("AccentColor")), // Use the asset catalog color
        ColorChoice(id: "green", name: "color.green", color: .green),
        ColorChoice(id: "red", name: "color.red", color: .red),
        ColorChoice(id: "purple", name: "color.purple", color: .purple),
        ColorChoice(id: "orange", name: "color.orange", color: .orange)
    ]
    
    // This will store the ID of the selected color.
    @Published var selectedColorId: String {
        didSet {
            UserDefaults.standard.set(selectedColorId, forKey: "accentColorId")
        }
    }
    
    // A helper to easily get the full Color object.
    var currentAccentColor: Color {
        (colorOptions.first(where: { $0.id == selectedColorId }) ?? colorOptions.first)!.color
    }

    // ✅ ADD THIS FUNCTION
    // This function takes a color name (like "green") and returns the actual Color object.
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

    // When the class is initialized, load the saved color ID.
    private init() {
        self.selectedColorId = UserDefaults.standard.string(forKey: "accentColorId") ?? "default"
    }
}
