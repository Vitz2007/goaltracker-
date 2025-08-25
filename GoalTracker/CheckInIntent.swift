//
//  CheckInIntent.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/04.
//

import AppIntents
import SwiftData
import UIKit // Import UIKit for haptic feedback

// This struct defines a single, reusable action: checking in on a goal.
struct CheckInIntent: AppIntent {
    // A user-facing title for the action.
    static var title: LocalizedStringResource = "intent.checkin.title"
    
    // This property will hold the unique ID of the goal we want to check in on.
    @Parameter(title: "intent.goalID.param.title")
    var goalID: String
    
    init() {
        self.goalID = ""
    }
    
    init(goalID: UUID) {
        self.goalID = goalID.uuidString
    }
    
    // This is the code that runs when the widget button is tapped.
    @MainActor
    func perform() async throws -> some IntentResult {
        // 1. Load all goals from the shared JSON file.
        var allGoals = DataManager.shared.load()
        
        // 2. Find the index of the specific goal to update.
        guard let uuid = UUID(uuidString: goalID),
              let goalIndex = allGoals.firstIndex(where: { $0.id == uuid })
        else {
            return .result()
        }
        
        // 3. Perform the check-in.
        let newCheckIn = CheckInRecord(date: Date())
        allGoals[goalIndex].checkIns.append(newCheckIn)
        
        // 4. Save the entire updated array back to the JSON file.
        DataManager.shared.save(goals: allGoals)
        
        // Provide haptic feedback
        let haptic = UIImpactFeedbackGenerator(style: .medium)
        haptic.impactOccurred()
        
        return .result()
    }
}
