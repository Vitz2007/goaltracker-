//
//  DayActivity.swift
//  GoalTracker
//
//  Created by AJ on 2025/08/18.
//

import Foundation

// Moved DayActivity to smash bug
struct DayActivity: Identifiable {
    let id = UUID()
    let date: Date
    let checkInCount: Int
}
