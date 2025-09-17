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
<<<<<<< HEAD
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
=======
        VStack(spacing: 4) {
            if let startDate = startDate {
                Text("Start Date: \(startDate, style: .date)")
            }
            if let dueDate = dueDate {
                Text("Deadline: \(dueDate, style: .date)")
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
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
