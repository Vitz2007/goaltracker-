//
//  Goal.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/14.
//

import Foundation

struct Goal: Identifiable, Codable {
    var id = UUID()
    var title: String
    var dueDate: Date?
    var isCompleted: Bool = false
}
