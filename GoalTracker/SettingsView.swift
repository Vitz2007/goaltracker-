//
//  SettingsView.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/23.
//

import SwiftUI

struct SettingsView: View{
    // Access to settings object
    @State private var appSettings = AppSettings.shared
    
    // For "Done" button
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Features")) {
                    // Toggle to read and write value from out AppSettings
                    Toggle("Enable Momentum Tracking", isOn: $appSettings.streaksEnabled)
                }
                
                Section(header: Text("About")) {
                    Text("Your App Name")
                    Text("Version 1.0.0") // Can update later
                }
            }
            .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
#Preview {
    SettingsView()
}
