//
//  SettingsView.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/23.
//

import SwiftUI

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
                    Picker(selection: $settings.selectedColorId) {
                        ForEach(settings.colorOptions) { option in
                            HStack {
                                Text(LocalizedStringKey(option.name))
                                Spacer()
                                Circle().fill(option.color).frame(width: 20, height: 20)
                            }.tag(option.id)
                        }
                    } label: {
                        Text("settings.theme")
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section {
                    NavigationLink {
                        LanguageSelectionView()
                    } label: {
                        HStack {
                            Text("settings.language")
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

#Preview {
    SettingsView()
        .environmentObject(AppSettings.shared)
}
