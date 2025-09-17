//
//  SortAndFilterOptions.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/12.
//
<<<<<<< HEAD

import SwiftUI
=======
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
import Foundation

enum SortOrder: String, CaseIterable, Identifiable {
    case byTitle = "Title"
    case byDueDate = "Due Date"
    case byCreationDate = "Creation Date"
    
    var id: String { self.rawValue }
}

enum GoalFilter: String, CaseIterable, Identifiable {
<<<<<<< HEAD
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
=======
    case all = "Show All"
    case active = "Show Active Only"
    
    var id: String { self.rawValue }
}

enum GoalCadence: String, CaseIterable, Identifiable, Codable {
    case daily = "Every Day"
    case everyTwoDays = "Every 2 Days"
    case everyThreeDays = "Every 3 Days"
    case weekly = "Once a Week"
    
    var id: String { self.rawValue }
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
}
