//
//  ActivityLogView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//

import SwiftUI

// Cleaner code to go with GoalDetailView.swift
struct ActivityLogView: View {
    let goal: Goal // Major key line and to expect a 'Goal'.
    
    // Create helper to make dates look nicer
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        NavigationView {
            VStack {
                // A nice message presented when there's no history yet.
                if goal.checkIns.isEmpty {
                    Text("No check-ins yet.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    // Display the check-ins in a List.
                    // .sorted() makes the newest ones appear at the very top.
                    List(goal.checkIns.sorted(by: { $0.date > $1.date })) { checkIn in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(dateFormatter.string(from: checkIn.date))
                                .fontWeight(.semibold)
                            
                            // Only show the note if it exists and isn't empty.
                            if let note = checkIn.note, !note.isEmpty {
                                Text(note)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Activity Log")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
