//
//  Goal.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/14.
//

// In Goal.swift

import Foundation

// Structure to hold data for one in our chart
struct DayActivity: Identifiable {
    let id = UUID()
    let date: Date
    let checkInCount: Int
}

// Enum to show different states of Momentum Halo
enum HaloState {
    case none
    case active
    case earned
}

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
    
    var haloState: HaloState {
            // First, let's calculate the streak number using our existing rules.
            guard !checkIns.isEmpty else { return .none }
            
            let calendar = Calendar.current
            let uniqueDates = Set(checkIns.map { calendar.startOfDay(for: $0.date) })
            let sortedDates = uniqueDates.sorted(by: >)
            
            guard let mostRecentDate = sortedDates.first else { return .none }
            
            let daysSinceLastCheckIn = calendar.dateComponents([.day], from: mostRecentDate, to: calendar.startOfDay(for: Date())).day ?? 0
            
            let allowedGap: Int
            switch self.cadence {
            case .daily: allowedGap = 1
            case .everyTwoDays: allowedGap = 2
            case .everyThreeDays: allowedGap = 3
            case .weekly: allowedGap = 7
            }
            
            if daysSinceLastCheckIn > allowedGap {
                return .none // Streak is broken.
            }
            
            var streakCount = 1
            for i in 0..<(sortedDates.count - 1) {
                let daysBetween = calendar.dateComponents([.day], from: sortedDates[i+1], to: sortedDates[i]).day ?? 0
                if daysBetween <= allowedGap {
                    streakCount += 1
                } else {
                    break
                }
            }
            
            // Now, determine the HaloState based on the streak count.
            if streakCount == 1 && calendar.isDateInToday(mostRecentDate) {
                // If the streak is 1 AND the check-in was today, it's a "comeback" or new streak.
                return .earned
            } else if streakCount >= 1 {
                // If the streak is 1 (from yesterday) or more, it's active.
                return .active
            } else {
                return .none
            }
        }
    
    // Computed property to generate data for bar chart with smarter start of week
    var recentActivity: [DayActivity] {
            let calendar = Calendar.current
            var activity = [DayActivity]()
            
            // Find the starting day of the current week based on the user's locale.
            guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
                return [] // Return empty if can't find the start of the week
            }
    
    // Looping through the last 7 days starting from 6 days ago until present day
        for i in 0..<7 {
                    if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                        let startOfDay = calendar.startOfDay(for: date)
                        
                        // 3. Count check-ins for that specific day.
                        let count = self.checkIns.filter {
                            calendar.isDate($0.date, inSameDayAs: startOfDay)
                        }.count
                        
                        activity.append(DayActivity(date: startOfDay, checkInCount: count))
                    }
                }
                return activity
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
