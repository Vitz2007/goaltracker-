//
//  GoalTrackerv2App.swift
//  GoalTrackerv2
//
//  Created by AJ on 2025/06/24.
//

// In GoalTrackerv2App.swift

import SwiftUI

@main
struct GoalTrackerApp: App {
    @StateObject private var settings = AppSettings.shared
    @AppStorage("app_language") var appLanguage: String = "en"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .id(appLanguage)
        }
        // The .modelContainer modifier has been removed.
    }
}
