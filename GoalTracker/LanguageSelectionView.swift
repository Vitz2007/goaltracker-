//
//  LanguageSelectionView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/22.
//

import SwiftUI

struct LanguageSelectionView: View {
    static let languages: [Language] = [
        Language(code: "en", nameKey: "language.name.en_US"),
        Language(code: "en-GB", nameKey: "language.name.en_GB"),
        Language(code: "ja", nameKey: "language.name.ja"),
        Language(code: "es", nameKey: "language.name.es"),
        Language(code: "fr", nameKey: "language.name.fr"),
        Language(code: "de", nameKey: "language.name.de"),
        Language(code: "zh-Hans", nameKey: "language.name.zh_Hans")
    ]
    
    @AppStorage("app_language") private var selectedLanguageCode: String = "en"
    
    var body: some View {
        Form {
            Section(footer: Text("language.change.note")) {
                Picker("language.picker.accessibilityTitle", selection: $selectedLanguageCode) {
                    ForEach(Self.languages) { language in
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
        }
    }
}
