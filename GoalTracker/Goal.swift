//
//  Goal.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/14.
//

import Foundation

struct CheckInRecord: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var note: String?

    init(id: UUID = UUID(), date: Date = Date(), note: String? = nil) {
        self.id = id
        self.date = date
        self.note = note
    }
}

struct Goal: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var startDate: Date?
    var dueDate: Date?
    var isCompleted: Bool
    var completionPercentage: Double
    var checkIns: [CheckInRecord]
    var targetCheckIns: Int
    var reminderIsEnabled: Bool
    var reminderDate: Date
    var cadence: GoalCadence
    var categoryID: UUID?
    var iconName: String?
    var isArchived: Bool = false

    init(id: UUID = UUID(),
         title: String,
         startDate: Date? = nil,
         dueDate: Date? = nil,
         isCompleted: Bool = false,
         completionPercentage: Double = 0.0,
         checkIns: [CheckInRecord] = [],
         targetCheckIns: Int = 30,
         reminderIsEnabled: Bool = false,
         reminderDate: Date = Date(),
         cadence: GoalCadence = .daily,
         categoryID: UUID? = nil,
         iconName: String? = nil,
         isArchived: Bool = false) {
        
        self.id = id
        self.title = title
        self.startDate = startDate
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.completionPercentage = max(0.0, min(1.0, completionPercentage))
        self.checkIns = checkIns
        self.targetCheckIns = max(1, targetCheckIns)
        self.reminderIsEnabled = reminderIsEnabled
        self.reminderDate = reminderDate
        self.cadence = cadence
        self.categoryID = categoryID
        self.iconName = iconName
        self.isArchived = isArchived
    }
}
