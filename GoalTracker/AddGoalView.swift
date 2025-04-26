//
//  AddGoalView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/14.
//

import SwiftUI

struct AddGoalView: View {
    @Binding var goals: [Goal]
    @Binding var showingAddGoal: Bool
    @State private var newGoalTitle = ""
    @State private var newGoalDueDate = Date()
    var onGoalAdded: () -> Void // Closure to trigger saving in ContentView

    var body: some View {
        NavigationView {
            Form {
                TextField("Goal Title", text: $newGoalTitle)
                DatePicker("Due Date (Optional)", selection: $newGoalDueDate, displayedComponents: .date)

                Button("Add Goal") {
                    if !newGoalTitle.isEmpty {
                        let newGoal = Goal(title: newGoalTitle, dueDate: newGoalDueDate)
                        goals.append(newGoal)
                        onGoalAdded() // Call the closure to save
                        showingAddGoal = false
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Add New Goal")
            .toolbar {
                Button("Cancel") {
                    showingAddGoal = false
                }
            }
        }
    }
}
