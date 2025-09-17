//
<<<<<<< HEAD
//  GoalTrackerv2App.swift
//  GoalTrackerv2
//
//  Created by AJ on 2025/06/24.
//

// In GoalTrackerv2App.swift

=======
//  GoalTrackerApp.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/07.
//
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
import SwiftUI

@main
struct GoalTrackerApp: App {
<<<<<<< HEAD
    @StateObject private var settings = AppSettings.shared
    @AppStorage("app_language") var appLanguage: String = "en"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                                // ✅ This modifier forces the entire view to be recreated when the language changes
                                .id(appLanguage)
                                // ✅ This modifier injects the selected locale into the environment for all views
                                .environment(\.locale, Locale(identifier: appLanguage))
                        }
                    }
                }
=======
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
