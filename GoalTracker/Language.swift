//
//  Language.swift
//  GoalTracker
//
//  Created by AJ on 2025/09/12.
//

import Foundation

struct Language: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let nameKey: String
}
