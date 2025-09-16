//
//  EditMotivationView.swift
//  GoalTracker
//
//  Created by AJ on 2025/09/12.
//

import SwiftUI

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
