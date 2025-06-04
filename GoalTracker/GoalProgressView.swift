//
//  GoalProgressView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/12.
//

// In GoalProgressView.swift
import SwiftUI
// Import Charts // No longer directly needed here DonutChartView handles it

struct GoalProgressView: View {
    let goal: Goal
    @Environment(\.dismiss) var dismiss

    // Helper to format the last check-in date nicely - remains here as it's specific to this view's needs
    private var lastCheckInDisplayString: String {
        // Sort checkIns by date to find the most recent one
        if let lastCheckInRecord = goal.checkIns.max(by: { $0.date < $1.date }) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: lastCheckInRecord.date)
        }
        return "Never"
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) { // Overall VStack
                    Text(goal.title) // << The title ==
                        .font(.title2) // Current font for the title
                        .fontWeight(.semibold)
                        .padding(.top)
                        .multilineTextAlignment(.center)

                    DonutChartView( // << The donut chart ==
                        completionPercentage: goal.completionPercentage,
                        primaryColor: .orange,
                        secondaryColor: Color.gray.opacity(0.3)
                    )
                    .padding(.top, 35)

                    GoalDateInfoView(startDate: goal.startDate, dueDate: goal.dueDate)

                    Divider()
                        .padding(.vertical, 10)

                    ActivityLogView(
                        checkIns: goal.checkIns,
                        lastCheckInDisplayString: lastCheckInDisplayString
                    )

                    Spacer() // Pushes content upwards
                }
                .padding(.bottom)
            }
            .navigationTitle("")
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

// In GoalProgressView.swift

struct GoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCheckInRecords: [CheckInRecord] = [ // << Use CheckInRecord
            CheckInRecord(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, note: "Preview Note 1"),
            CheckInRecord(date: Calendar.current.date(byAdding: .hour, value: -8, to: Date())!, note: "Another Preview Note"),
            CheckInRecord(date: Date(), note: nil)
        ]
        GoalProgressView(
            goal: Goal(
                title: "My Active Goal with Progress",
                startDate: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()),
                dueDate: Calendar.current.date(byAdding: .month, value: 1, to: Date()),
                isCompleted: false,
                completionPercentage: 0.65,
                checkIns: sampleCheckInRecords, // << Pass [CheckInRecord]
                targetCheckIns: 30
            )
        )
    }
}
