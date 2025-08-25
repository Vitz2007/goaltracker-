//
//  SortAndFilterOptions.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/12.
//

import SwiftUI
import Foundation

enum SortOrder: String, CaseIterable, Identifiable {
    case byTitle = "Title"
    case byDueDate = "Due Date"
    case byCreationDate = "Creation Date"
    
    var id: String { self.rawValue }
}

enum GoalFilter: String, CaseIterable, Identifiable {
    case active = "Active"
    case all = "All"
    
    var id: Self { self }
    
    // ✅ ADD THIS COMPUTED PROPERTY
    // This provides the correct key for the current filter case.
    var localizedKey: LocalizedStringKey {
        switch self {
        case .active:
            return "contentView.filter.active"
        case .all:
            return "contentView.filter.all"
        }
    }
}

enum GoalCadence: String, CaseIterable, Identifiable, Codable {
    // ✅ Raw values are now simple identifiers
    case daily = "daily"
    case everyTwoDays = "everyTwoDays"
    case everyThreeDays = "everyThreeDays"
    case weekly = "weekly"
    
    var id: String { self.rawValue }

    // ✅ This property provides the correct key for localization
    var localizedKey: LocalizedStringKey {
        switch self {
        case .daily:
            return "cadence.daily"
        case .everyTwoDays:
            return "cadence.everyTwoDays"
        case .everyThreeDays:
            return "cadence.everyThreeDays"
        case .weekly:
            return "cadence.weekly"
        }
    }
}
