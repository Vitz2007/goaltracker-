//
//  AppSettings.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/23.
//

// In AppSettings.swift

import SwiftUI

// A simple struct to define our color options.
struct ColorChoice: Identifiable, Hashable {
    let id: String
    let name: String
    let color: Color
}

final class AppSettings: ObservableObject {
    // Make this a shared instance so all views access the same settings.
    static let shared = AppSettings()

    // The list of colors the user can choose from.
    let colorOptions: [ColorChoice] = [
        // localize color names, name property holds localization key
        ColorChoice(id: "default", name: "color.defaultBlue", color: .accentColor),
        ColorChoice(id: "green", name: "color.green", color: .green),
        ColorChoice(id: "red", name: "color.red", color: .red),
        ColorChoice(id: "purple", name: "color.purple", color: .purple),
        ColorChoice(id: "orange", name: "color.orange", color: .orange)
    ]
    
    // This will store the ID of the selected color.
    // When it changes, we save the new ID to UserDefaults.
    @Published var selectedColorId: String {
        didSet {
            UserDefaults.standard.set(selectedColorId, forKey: "accentColorId")
        }
    }
    
    // A helper to easily get the full Color object.
    var currentAccentColor: Color {
        (colorOptions.first(where: { $0.id == selectedColorId }) ?? colorOptions.first)!.color
    }

    // When the class is initialized, load the saved color ID.
    private init() {
        self.selectedColorId = UserDefaults.standard.string(forKey: "accentColorId") ?? "default"
    }
}
