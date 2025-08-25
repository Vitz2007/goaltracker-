//
//  DashboardViewModel.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/06.
//

import Foundation
import SwiftUI

@Observable
class DashboardViewModel {
    // This ViewModel is now initialized with the data it needs
    init(goals: [Goal]) {
        self.allGoals = goals
        calculateStats()
    }
    
    private var allGoals: [Goal]
    
    var checkInsThisWeek: Int = 0
    var checkInsThisMonth: Int = 0
    var completedGoals: [Goal] = []
    var activeDays: Set<DateComponents> = []
    
    // The ViewModel no longer fetches data, it just calculates it.
    private func calculateStats() {
        let allCheckInDates = allGoals.flatMap { $0.checkIns.map { $0.date } }
        let now = Date()
        let calendar = Calendar.current
        
        if let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now) {
            checkInsThisWeek = allCheckInDates.filter { $0 >= oneWeekAgo }.count
        }
        
        if let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) {
            checkInsThisMonth = allCheckInDates.filter { $0 >= startOfMonth }.count
        }
        
        completedGoals = allGoals.filter { $0.isCompleted && !$0.isArchived }
        
        self.activeDays = Set(allCheckInDates.map { date in
            calendar.dateComponents([.year, .month, .day], from: date)
        })
    }
}
