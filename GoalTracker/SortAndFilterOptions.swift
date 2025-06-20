//
//  SortAndFilterOptions.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/12.
//
import Foundation

enum SortOrder: String, CaseIterable, Identifiable {
    case byTitle = "Title"
    case byDueDate = "Due Date"
    case byCreationDate = "Creation Date"
    
    var id: String { self.rawValue }
}

enum GoalFilter: String, CaseIterable, Identifiable {
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
}
