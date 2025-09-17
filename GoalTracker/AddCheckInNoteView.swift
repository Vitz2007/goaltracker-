//
//  AddCheckInNoteView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/30.
//

// Create a new Swift file:
// AddCheckInNoteView.swift

import SwiftUI

struct AddCheckInNoteView: View {
    @Environment(\.dismiss) var dismiss
    @State private var note: String = ""
    
    // Closure to pass the note back
    var onSave: (String?) -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $note)
                    .frame(height: 150)
                    .border(Color.gray, width: 1)
                    .padding()

                Spacer()
            }
<<<<<<< HEAD
            .navigationTitle("addNote.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("common.skip") {
=======
            .navigationTitle("Add a Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Skip") {
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                        onSave(nil) // Pass back nil for no note
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
<<<<<<< HEAD
                    Button("common.save") {
=======
                    Button("Save") {
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                        onSave(note.isEmpty ? nil : note) // Pass back the note, or nil if empty
                        dismiss()
                    }
                }
            }
        }
    }
}
