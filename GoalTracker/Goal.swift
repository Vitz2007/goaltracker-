//
//  Goal.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/14.
//

// In Goal.swift
import Foundation

struct Goal: Identifiable, Codable {
    let id: UUID
    var title: String
    var startDate: Date?
    var dueDate: Date?
    var isCompleted: Bool
    var completionPercentage: Double // << NEW PROPERTY (0.0 to 1.0)

    init(id: UUID = UUID(),
         title: String,
         startDate: Date? = nil,
         dueDate: Date? = nil,
         isCompleted: Bool = false,
         completionPercentage: Double = 0.0) { // << NEW PARAMETER with default
        self.id = id
        self.title = title
        self.startDate = startDate
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.completionPercentage = max(0.0, min(1.0, completionPercentage)) // Ensure it's between 0 and 1
    }
}
