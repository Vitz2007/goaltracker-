//
//  AddGoalViewModel.swift
//  GoalTracker
//
//  Created by AJ on 2025/08/28.
//

import SwiftUI

class AddGoalViewModel: ObservableObject {
    @Published var newGoalTitle: String = ""
    @Published var newGoalDueDate: Date = Date()
    @Published var newGoalTargetCheckIns: Int = 30
    @Published var includeStartDate: Bool = false
    @Published var selectedStartDate: Date = Date()
    @Published var reminderIsEnabled: Bool = false
    @Published var reminderDate: Date = Date()
    @Published var selectedCadence: GoalCadence = .daily
    @Published var selectedCategoryID: UUID?
    @Published var selectedPresetID: UUID?
    @Published var selectedIconName: String? = "target"
    @Published var showingIconPicker = false
    @Published var newGoalCompletionPercentage: Double = 0.0
    
    let appSettings: AppSettings

    var selectedCategory: GoalCategory? {
        GoalLibrary.categories.first { $0.id == selectedCategoryID }
    }
    
    var isSaveDisabled: Bool {
        newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(settings: AppSettings) {
        self.appSettings = settings
    }
    
    func resetPreset() {
        self.selectedPresetID = nil
    }
    
    func updateTitleFromPreset() {
        guard let presetID = selectedPresetID else {
            newGoalTitle = ""
            return
        }
        if let preset = selectedCategory?.presets.first(where: { $0.id == presetID }) {
            let localizedTemplate = NSLocalizedString(preset.template, comment: "")
            newGoalTitle = localizedTemplate
        }
    }
}
