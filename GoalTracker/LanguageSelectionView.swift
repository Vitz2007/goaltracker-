//
//  LanguageSelectionView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/22.
//

import SwiftUI

struct LanguageSelectionView: View {
    // The 'name' property is now 'nameKey' to reflect that it holds a key
    private let languageOptions: [(nameKey: String, code: String)] = [
        ("language.name.en_US", "en"),
        ("language.name.en_GB", "en-GB"),
        ("language.name.ja", "ja"),
        ("language.name.es", "es"),
        ("language.name.fr", "fr"),
        ("language.name.de", "de"),
        ("language.name.zh_Hans", "zh-Hans")
    ]
    
    // This stores the KEY of the selected language name
    @AppStorage("selectedLanguage") private var selectedLanguageNameKey: String = "language.name.en_US"
    
    // This stores the language CODE and drives the selection
    @AppStorage("app_language") private var selectedLanguageCode: String = "en"
    
    // The init() and extra @State property are removed as they are no longer needed.

    var body: some View {
        Form {
            Section(footer: Text("language.change.note")) {
                Picker("language.picker.accessibilityTitle", selection: $selectedLanguageCode) {
                    ForEach(languageOptions, id: \.code) { language in
                        Text(LocalizedStringKey(language.nameKey)).tag(language.code)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
        }
        .navigationTitle("language.selector.title")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedLanguageCode) { _, newCode in
            UserDefaults.standard.set([newCode], forKey: "AppleLanguages")
            
            // Find the matching KEY and update the AppStorage property
            if let newNameKey = languageOptions.first(where: { $0.code == newCode })?.nameKey {
                selectedLanguageNameKey = newNameKey
            }
        }
    }
}

#Preview {
    NavigationStack {
        LanguageSelectionView()
    }
}
