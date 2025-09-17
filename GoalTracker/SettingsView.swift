//
//  SettingsView.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/23.
//

import SwiftUI

<<<<<<< HEAD
struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("app_language") private var selectedLanguageCode: String = "en"

    private var selectedLanguageNameKey: String {
        LanguageSelectionView.languages.first { $0.code == selectedLanguageCode }?.nameKey ?? "language.name.en_US"
    }
    
    @State private var showingEditMotivationSheet = false
    @AppStorage("userMotivation") private var userMotivation: String = ""
    private let motivationalQuoteKeys = [ "quote.1", "quote.2", "quote.3", "quote.4", "quote.5" ]
    @State private var currentQuoteIndex = 0

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("settings.motivation.header")) {
                    VStack(alignment: .leading, spacing: 12) {
                        if userMotivation.isEmpty {
                            Text(LocalizedStringKey(motivationalQuoteKeys[currentQuoteIndex]))
                                .italic().foregroundColor(.secondary).id(currentQuoteIndex)
                        } else {
                            Text(userMotivation).italic().foregroundColor(.secondary)
                        }
                        HStack {
                            Spacer()
                            Button("settings.motivation.anotherQuoteButton") {
                                userMotivation = ""
                                currentQuoteIndex = (currentQuoteIndex + 1) % motivationalQuoteKeys.count
                            }
                            .buttonStyle(.borderless)
                            Button("settings.motivation.writeOwnButton") {
                                showingEditMotivationSheet = true
                            }
                            .buttonStyle(.borderless)
                        }
                        .font(.footnote)
                    }
                    .padding(.vertical, 8)
                }

                Section(header: Text("settings.section.appearance")) {
                    // Restored the previous UI for color selection
                    Picker(selection: $settings.selectedColorId) {
                        ForEach(settings.colorOptions) { option in
                            HStack {
                                Text(LocalizedStringKey(option.name))
                                Spacer()
                                Circle().fill(option.color).frame(width: 20, height: 20)
                            }.tag(option.id)
                        }
                    } label: { // Added a label here and wrapped in LocalizedStringKey
                        Text("settings.theme")
                    }
                    .pickerStyle(.navigationLink) // Ensuring it uses the navigation link style
                }
                
                Section {
                    NavigationLink {
                        LanguageSelectionView()
                    } label: {
                        HStack {
                            Text("settings.language") // Wrapped in LocalizedStringKey
                            Spacer()
                            Text(LocalizedStringKey(selectedLanguageNameKey))
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Section(header: Text("settings.data.header")) {
                    NavigationLink {
                        ArchivedGoalsView()
                    } label: {
                        Label("settings.data.viewArchived", systemImage: "archivebox.fill")
                    }
                }
                
                Section {
                    Link(destination: URL(string: "mailto:support@goaltrapperapp.com")!) {
                        HStack {
                            Text("settings.support.label")
                            Spacer()
                            Image(systemName: "arrow.up.right").font(.footnote.bold()).foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("settings.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("common.done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingEditMotivationSheet) {
                EditMotivationView(userMotivation: $userMotivation)
            }
        }
    }
}
=======
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
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
