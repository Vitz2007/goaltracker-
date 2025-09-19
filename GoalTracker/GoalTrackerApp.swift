//
//  GoalTrackerApp.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/24.
//

import SwiftUI

@main
struct GoalTrackerApp: App {
    @StateObject private var settings = AppSettings.shared
    @AppStorage("app_language") var appLanguage: String = "en"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .tint(settings.currentAccentColor)
                // This modifier forces the entire view to be recreated when the language changes
                .id(appLanguage)
                // This modifier injects the selected locale into the environment for all views
                .environment(\.locale, Locale(identifier: appLanguage))
        }
    }
}
