//
//  GoalDateInfoView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//
import SwiftUI

struct GoalDateInfoView: View {
    let startDate: Date?
    let dueDate: Date?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) { //update to .leading alignment for cleaner look
            if let startDate = startDate {
                Text("goal.startDate.label")
                Text(startDate, style: .date)
            }
            if let dueDate = dueDate {
                HStack(spacing: 4) {
                    Text("goal.deadline.label")
                    Text(dueDate, style: .date)
                }
            }
        }
        .font(.system(size: 18))
        .foregroundColor(.primary)
    }
}

struct GoalDateInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GoalDateInfoView(
            startDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
            dueDate: Date()
        )
    }
}
