//
//  ProgressView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/26.
//
import SwiftUI

struct ProgressView: View {
    let goal: Goal // Receive the goal to show progress for

    var body: some View {
        VStack {
            Text("Progress for \(goal.title)")
                .font(.title)
            // TODO: Add progress tracking UI later based on user requirements
            Spacer()
        }
        .navigationTitle("Goal Progress")
    }
}
