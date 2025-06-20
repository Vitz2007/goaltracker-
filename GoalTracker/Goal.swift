//
//  Goal.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/14.
//

// In Goal.swift
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


// Updated goal struct
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
    var cadence: GoalCadence = .daily

    var currentStreak: Int {
        guard !checkIns.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let uniqueDates = Set(checkIns.map { calendar.startOfDay(for: $0.date) })
        let sortedDates = uniqueDates.sorted(by: >)
        
        guard let mostRecentDate = sortedDates.first else { return 0 }
        
        let daysSinceLastCheckIn = calendar.dateComponents([.day], from: mostRecentDate, to: Date()).day ?? 0
        
        let allowedGap: Int
        switch self.cadence {
        case .daily:
            allowedGap = 1
        case .everyTwoDays:
            allowedGap = 2
        case .everyThreeDays:
            allowedGap = 3
        case .weekly:
            allowedGap = 7
        }
        
        if daysSinceLastCheckIn > allowedGap {
            return 0
        }
        
        var streakCount = 1
        for i in 0..<(sortedDates.count - 1) {
            let currentDate = sortedDates[i]
            let previousDate = sortedDates[i+1]
            
            let daysBetween = calendar.dateComponents([.day], from: previousDate, to: currentDate).day ?? 0
            
            if daysBetween <= allowedGap {
                streakCount += 1
            } else {
                break
            }
        }
        
        return streakCount
    }

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
         cadence: GoalCadence = .daily) {
        
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
    }
}
