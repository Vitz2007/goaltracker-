//
//  GoalProgressView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/12.
//

import SwiftUI

struct GoalProgressView: View {
    let goal: Goal
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text(LocalizedStringKey(goal.title))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .multilineTextAlignment(.center)

                    DonutChartView(
                        completionPercentage: goal.completionPercentage,
                        primaryColor: .orange,
                        secondaryColor: Color.gray.opacity(0.3)
                    )
                    .padding(.top, 35)

                    GoalDateInfoView(startDate: goal.startDate, dueDate: goal.dueDate)

                    Divider()
                        .padding(.vertical, 10)

                    ActivityLogView(goal: goal)

                    Spacer()
                }
                .padding(.bottom)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("common.done") {
                        dismiss()
                    }
                }
            }
        }
    }
}


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

