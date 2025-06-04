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
        VStack(spacing: 4) {
            if let startDate = startDate {
                Text("Start Date: \(startDate, style: .date)")
            }
            if let dueDate = dueDate {
                Text("Deadline: \(dueDate, style: .date)")
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
