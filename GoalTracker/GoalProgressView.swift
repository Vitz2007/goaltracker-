//
//  GoalProgressView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/12.
//

<<<<<<< HEAD
import SwiftUI
=======
// In GoalProgressView.swift
import SwiftUI
// Import Charts // No longer directly needed here DonutChartView handles it
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484

struct GoalProgressView: View {
    let goal: Goal
    @Environment(\.dismiss) var dismiss

<<<<<<< HEAD
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text(LocalizedStringKey(goal.title))
                        .font(.title2)
=======

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) { // Overall VStack
                    Text(goal.title) // << The title ==
                        .font(.title2) // Current font for the title
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                        .fontWeight(.semibold)
                        .padding(.top)
                        .multilineTextAlignment(.center)

<<<<<<< HEAD
                    DonutChartView(
=======
                    DonutChartView( // << The donut chart ==
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                        completionPercentage: goal.completionPercentage,
                        primaryColor: .orange,
                        secondaryColor: Color.gray.opacity(0.3)
                    )
                    .padding(.top, 35)

                    GoalDateInfoView(startDate: goal.startDate, dueDate: goal.dueDate)

                    Divider()
                        .padding(.vertical, 10)

                    ActivityLogView(goal: goal)

<<<<<<< HEAD
                    Spacer()
=======
                    Spacer() // Pushes content upwards
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                }
                .padding(.bottom)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
<<<<<<< HEAD
                    Button("common.done") {
=======
                    Button("Done") {
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                        dismiss()
                    }
                }
            }
        }
    }
}

<<<<<<< HEAD

#Preview {
    // ✅ 1. Create an array of CheckInRecord objects, not just Dates.
    let sampleCheckInRecords: [CheckInRecord] = [
        CheckInRecord(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!),
        CheckInRecord(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
        CheckInRecord(date: Date())
    ]
    
    // ✅ 2. Create the Goal using the correct 'checkIns' parameter name.
    let sampleGoal = Goal(
        title: "My Active Goal with Progress",
        startDate: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()),
        dueDate: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
        isCompleted: false,
        completionPercentage: 0.65,
        checkIns: sampleCheckInRecords, // Use the correct parameter name
        targetCheckIns: 30,
        cadence: .daily
    )
    
    return GoalProgressView(goal: sampleGoal)
}

=======
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
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
