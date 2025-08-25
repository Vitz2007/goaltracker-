//
//  DataManager.swift
//  GoalTracker
//
//  Created by AJ on 2025/08/23.
//

import Foundation

class DataManager {
    // A shared instance to access from anywhere in the app
    static let shared = DataManager()

    // The URL for the saved data file in the shared container
    private var fileURL: URL {
        let groupIdentifier = "group.com.kioshi.GoalTracker" // Use your App Group ID
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) else {
            fatalError("Failed to get container URL for App Group.")
        }
        return containerURL.appendingPathComponent("goals.json")
    }

    // A function to load the array of goals from the file
    func load() -> [Goal] {
        do {
            let data = try Data(contentsOf: fileURL)
            let goals = try JSONDecoder().decode([Goal].self, from: data)
            return goals
        } catch {
            // If it fails (e.g., the file doesn't exist yet), return an empty array.
            print("Failed to load goals: \(error.localizedDescription)")
            return []
        }
    }

    // A function to save the array of goals to the file
    func save(goals: [Goal]) {
        do {
            let data = try JSONEncoder().encode(goals)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save goals: \(error.localizedDescription)")
        }
    }
}
