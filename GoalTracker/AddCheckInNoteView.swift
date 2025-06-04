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
    @State private var noteText: String = ""
    let onComplete: (String?) -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Text("Add a note to your check-in (optional):")
                    .font(.headline)
                    .padding(.top)

                TextEditor(text: $noteText)
                    .frame(height: 200)
                    .border(Color.gray.opacity(0.3), width: 1)
                    .cornerRadius(5)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Check-in Note")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Skip Note") {
                        print("DEBUG AddCheckInNoteView: 'Skip Note' button tapped.")
                        onComplete(nil)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        print("DEBUG AddCheckInNoteView: 'Done' button tapped. Note: '\(noteText)'")
                        let finalNote = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
                        onComplete(finalNote.isEmpty ? nil : finalNote)
                        dismiss()
                    }
                }
            }
            // --- END of revised TOOLBAR ---
        }
    }
}

struct AddCheckInNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddCheckInNoteView { noteText_from_preview in
            print("Preview: Note entered was - '\(noteText_from_preview ?? "No note provided")'")
        }
    }
}
