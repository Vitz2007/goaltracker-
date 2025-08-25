//
//  ActivityLogView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//

import SwiftUI

struct ActivityLogView: View {
    let goal: Goal
    
    // Get the current app language to format dates correctly
    @AppStorage("app_language") private var appLanguage: String = "en"
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: appLanguage) // Use selected language
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        NavigationView {
            VStack {
                // ✅ Checks the correct 'checkIns' array
                if goal.checkIns.isEmpty {
                    Text("activityLog.emptyState.message")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemGroupedBackground))
                } else {
                    // ✅ Iterates over the array of CheckInRecord objects
                    List(goal.checkIns.sorted(by: { $0.date > $1.date })) { record in
                        VStack(alignment: .leading, spacing: 4) {
                            // Display the date from the record
                            Text(dateFormatter.string(from: record.date))
                                .fontWeight(.semibold)
                            
                            // ✅ Display the note if it exists
                            if let note = record.note, !note.isEmpty {
                                Text(note)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("activityLog.title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview(NSLocalizedString("preview.activityLog.withCheckins", comment: "")) {
    // A sample goal for the preview
    let sampleRecords = [
        CheckInRecord(note: "First day was a success!"),
        CheckInRecord(date: .now.addingTimeInterval(-86400 * 2), note: "Feeling good.")
    ]
    
    let sampleGoalWithCheckIns = Goal(
        title: "Test Goal with History",
        dueDate: .now.addingTimeInterval(86400 * 30),
        checkIns: sampleRecords
    )
    
    // The view needs to be in a List or Form for the preview to look right
    return Form {
        ActivityLogView(goal: sampleGoalWithCheckIns)
    }
}

#Preview(NSLocalizedString("preview.activityLog.noCheckins", comment: "")) {
    let sampleGoalWithoutCheckIns = Goal(
        title: "New Empty Goal",
        dueDate: .now.addingTimeInterval(86400 * 10)
    )
        
    return Form {
        ActivityLogView(goal: sampleGoalWithoutCheckIns)
    }
}
