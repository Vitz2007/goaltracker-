//
//  GoalProgressView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/12.
//

import SwiftUI

struct GoalProgressView: View {
    let goal: Goal
    // No longer needs the @Environment dismiss property

    var body: some View {
        // The NavigationView has been removed
        ScrollView {
            VStack(spacing: 20) {
                // The redundant Text view for the title has been removed.
                
                DonutChartView(
                    completionPercentage: goal.completionPercentage,
                    primaryColor: Color.accentColor, // Uses the global accent color
                    secondaryColor: Color.gray.opacity(0.3)
                )
                .padding(.top, 35)

                GoalDateInfoView(startDate: goal.startDate, dueDate: goal.dueDate)

                Divider()
                    .padding(.vertical, 10)

                ActivityLogView(goal: goal)

                Spacer()
            }
            .padding() // Add padding for better spacing within the sheet
        }
    }
}


#Preview {
    let sampleCheckInRecords: [CheckInRecord] = [
        CheckInRecord(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!),
        CheckInRecord(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
        CheckInRecord(date: Date())
    ]
    
    let sampleGoal = Goal(
        title: "My Active Goal with Progress",
        startDate: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()),
        dueDate: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
        isCompleted: false,
        completionPercentage: 0.65,
        checkIns: sampleCheckInRecords,
        targetCheckIns: 30,
        cadence: .daily
    )
    
    return GoalProgressView(goal: sampleGoal)
}
