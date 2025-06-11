//
//  Goal.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/14.
//
import Foundation

// Identifiable and Codable
struct CheckInRecord: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var note: String?

    // Provide a default initializer if need be, especially if we want to create empty ones with ease
    // Or if properties have default values.
    init(id: UUID = UUID(), date: Date = Date(), note: String? = nil) {
        self.id = id
        self.date = date
        self.note = note
    }
}
// End of CheckInRecord


// Defining Goal STRUCT ---
struct Goal: Identifiable, Codable, Hashable {
    let id: UUID // No default value needed, handled by init
    var title: String
    var startDate: Date?
    var dueDate: Date?
    var isCompleted: Bool
    var completionPercentage: Double

    var checkIns: [CheckInRecord] // Now uses the defined CheckInRecord

    var targetCheckIns: Int

    // Initializer handles providing a default UUID for 'id'
    init(id: UUID = UUID(),
         title: String,
         startDate: Date? = nil,
         dueDate: Date? = nil,
         isCompleted: Bool = false,
         completionPercentage: Double = 0.0,
         checkIns: [CheckInRecord] = [], // Parameter uses defined CheckInRecord
         targetCheckIns: Int = 30) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.completionPercentage = max(0.0, min(1.0, completionPercentage))
        self.checkIns = checkIns
        self.targetCheckIns = max(1, targetCheckIns) // Ensure target is at least 1
    }
}
