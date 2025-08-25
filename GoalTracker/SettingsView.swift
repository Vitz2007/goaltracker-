//
//  SettingsView.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/23.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    // Get access to the shared AppSettings object.
    @EnvironmentObject var settings: AppSettings
    @Environment(\.dismiss) var dismiss
    
    // --- State Properties for Functionality ---
    
    private let motivationalQuoteKeys = [
        "quote.1", "quote.2", "quote.3", "quote.4", "quote.5"
    ]
    
    @State private var currentQuoteIndex = 0
    @State private var showingEditMotivationSheet = false
    @AppStorage("userMotivation") private var userMotivation: String = ""
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "English (US)"

    var body: some View {
        NavigationStack {
            Form {
                // --- Section 1: My Motivation ---
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        // Using an if/else block for clarity
                        if userMotivation.isEmpty {
                            // This correctly looks up the key from your .strings file
                            Text(LocalizedStringKey(motivationalQuoteKeys[currentQuoteIndex]))
                                .italic()
                                .foregroundColor(.secondary).id(currentQuoteIndex)
                        } else {
                            // This correctly displays the user's custom quote literally
                            Text(userMotivation)
                                .italic()
                                .foregroundColor(.secondary)
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
                } header: {
                    Text("settings.motivation.header")
                } footer: {
                    Text("settings.motivation.footer")
                }

                // ... The rest of your SettingsView file remains the same ...
                
                // --- Section 2: Appearance ---
                Section(header: Text("settings.appearance.header")) {
                    ForEach(settings.colorOptions) { option in
                        Button(action: {
                            settings.selectedColorId = option.id
                        }) {
                            HStack {
                                Text(LocalizedStringKey(option.name))
                                Spacer()
                                Circle().fill(option.color).frame(width: 20, height: 20)
                                if settings.selectedColorId == option.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // --- Section 3: Language ---
                Section {
                    NavigationLink {
                        LanguageSelectionView()
                    } label: {
                        HStack {
                            Text("language.selector.title")
                            Spacer()
                            Text(selectedLanguage)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // --- Section 4: Data Management ---
                Section(header: Text("settings.data.header")) {
                    NavigationLink {
                        ArchivedGoalsView()
                    } label: {
                        Label("settings.data.viewArchived", systemImage: "archivebox.fill")
                    }
                }
                
                // --- Section 5: Support & Feedback ---
                Section {
                    Link(destination: URL(string: "mailto:support@goaltrapperapp.com")!) {
                        HStack {
                            Text("settings.support.label")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.footnote.bold())
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("settings.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("common.done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingEditMotivationSheet) {
                EditMotivationView(userMotivation: $userMotivation)
            }
        }
    }
}

// This is the helper view for the "Write Your Own" sheet
struct EditMotivationView: View {
    @Binding var userMotivation: String
    @State private var text: String = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("editMotivation.placeholder", text: $text, axis: .vertical)
                    .lineLimit(5...)
            }
            .navigationTitle("editMotivation.title")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                text = userMotivation
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.save") {
                        userMotivation = text
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppSettings.shared)
    // The .modelContainer modifier has been removed.
}
