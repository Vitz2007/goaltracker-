//
//  GoalLibrary.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/26.
//

import Foundation
import SwiftUI

struct GoalPreset: Identifiable {
    let id = UUID()
    let title: String
    let template: String
    let rationale: String
}

struct GoalCategory: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let colorName: String
    let presets: [GoalPreset]
}

struct GoalLibrary {
    // ✅ CHANGED: This is now a 'static let' to ensure the IDs are stable.
    static let categories: [GoalCategory] = [
        // MARK: - Financial Goals
        GoalCategory(
            name: "category.financial.name",
            iconName: "dollarsign.circle.fill",
            colorName: "green",
            presets: [
                GoalPreset(title: "category.financial.preset.automateSavings.title", template: "category.financial.preset.automateSavings.template", rationale: "category.financial.preset.automateSavings.rationale"),
                GoalPreset(title: "category.financial.preset.accelerateDebt.title", template: "category.financial.preset.accelerateDebt.template", rationale: "category.financial.preset.accelerateDebt.rationale"),
                GoalPreset(title: "category.financial.preset.emergencyFund.title", template: "category.financial.preset.emergencyFund.template", rationale: "category.financial.preset.emergencyFund.rationale"),
                GoalPreset(title: "category.financial.preset.trackSpending.title", template: "category.financial.preset.trackSpending.template", rationale: "category.financial.preset.trackSpending.rationale")
            ]
        ),
        
        // MARK: - Health & Wellness Goals
        GoalCategory(
            name: "category.health.name",
            iconName: "heart.fill",
            colorName: "red",
            presets: [
                GoalPreset(title: "category.health.preset.workoutRoutine.title", template: "category.health.preset.workoutRoutine.template", rationale: "category.health.preset.workoutRoutine.rationale"),
                GoalPreset(title: "category.health.preset.improveNutrition.title", template: "category.health.preset.improveNutrition.template", rationale: "category.health.preset.improveNutrition.rationale"),
                GoalPreset(title: "category.health.preset.dailyMindfulness.title", template: "category.health.preset.dailyMindfulness.template", rationale: "category.health.preset.dailyMindfulness.rationale"),
                GoalPreset(title: "category.health.preset.digitalDetox.title", template: "category.health.preset.digitalDetox.template", rationale: "category.health.preset.digitalDetox.rationale")
            ]
        ),
        
        // MARK: - Career & Development Goals
        GoalCategory(
            name: "category.career.name",
            iconName: "briefcase.fill",
            colorName: "blue",
            presets: [
                GoalPreset(title: "category.career.preset.learnSkill.title", template: "category.career.preset.learnSkill.template", rationale: "category.career.preset.learnSkill.rationale"),
                GoalPreset(title: "category.career.preset.polishProfile.title", template: "category.career.preset.polishProfile.template", rationale: "category.career.preset.polishProfile.rationale")
            ]
        )
    ]
}
