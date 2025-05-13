//
//  EditGoalView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/26.
//

// In EditGoalView.swift
import SwiftUI

struct EditGoalView: View {
    @Environment(\.dismiss) var dismiss

    @State var goalToEdit: Goal // A mutable copy passed in
    var onSave: (Goal) -> Void

    // State for managing the optional start date UI
    @State private var includeStartDate: Bool
    @State private var selectedStartDateForPicker: Date // Temporary state for the DatePicker when it's visible

    // Custom initializer to set up our @State properties based on the passed goal
    init(goalToEdit: Goal, onSave: @escaping (Goal) -> Void) {
        // You need to initialize @State properties that don't have default values
        // using the underscore prefix for the State wrapper itself.
        self._goalToEdit = State(initialValue: goalToEdit)
        self.onSave = onSave

        if let existingStartDate = goalToEdit.startDate {
            self._includeStartDate = State(initialValue: true)
            self._selectedStartDateForPicker = State(initialValue: existingStartDate)
        } else {
            self._includeStartDate = State(initialValue: false)
            self._selectedStartDateForPicker = State(initialValue: Date()) // Default if user toggles it on
        }
    }

    var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Goal Details")) {
                        TextField("Goal Title", text: $goalToEdit.title)
                    }
                    
                    Section(header: Text("Progress")) {
                        VStack(alignment: .leading) {
                            Text("Completion: \(Int(goalToEdit.completionPercentage * 100))%")
                            Slider(
                                value: $goalToEdit.completionPercentage,
                                in: 0...1, // Represents 0% to 100%
                                step: 0.01 // Granularity of 1%
                            )
                        }
                    }

                    Section(header: Text("Dates")) {
                        Toggle("Set a Start Date", isOn: $includeStartDate.animation())
                            // UPDATED onChange for the Toggle:
                            .onChange(of: includeStartDate) { oldValue, newValue in
                                if !newValue { // If the toggle is now OFF
                                    goalToEdit.startDate = nil
                                } else { // If the toggle is now ON
                                    goalToEdit.startDate = selectedStartDateForPicker
                                }
                            }

                        if includeStartDate {
                            DatePicker("Start Date",
                                       selection: $selectedStartDateForPicker,
                                       in: ...(goalToEdit.dueDate ?? .distantFuture),
                                       displayedComponents: .date)
                                // UPDATED onChange for the DatePicker (this was likely your line 46 area):
                                .onChange(of: selectedStartDateForPicker) { oldValue, newValue in
                                    if includeStartDate {
                                        goalToEdit.startDate = newValue // Use the new value
                                    }
                                }
                                .id("startDatePicker-\(includeStartDate)")
                        }

                        DatePicker("Deadline",
                                   selection: Binding(
                                       get: { goalToEdit.dueDate ?? Date() },
                                       set: { goalToEdit.dueDate = $0 }
                                   ),
                                   in: (goalToEdit.startDate ?? .distantPast)...,
                                   displayedComponents: .date)
                    }
                }
            .navigationTitle("Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Before saving, ensure goalToEdit.startDate is correctly nil
                        // if the toggle is off.
                        if !includeStartDate {
                            goalToEdit.startDate = nil
                        } else {
                            // If toggle is on, ensure the selectedStartDate from picker is on goalToEdit
                            goalToEdit.startDate = selectedStartDateForPicker
                        }
                        onSave(goalToEdit)
                        dismiss()
                    }
                }
            }
        }
    }
}

// Updated Preview for EditGoalView
struct EditGoalView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample goal WITH a start date
        let sampleGoalWithStartDate = Goal(title: "Fitness Challenge",
                                           startDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()),
                                           dueDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
                                           isCompleted: false)

        // Sample goal WITHOUT a start date
        let sampleGoalWithoutStartDate = Goal(title: "Read New Book",
                                              startDate: nil,
                                              dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date()),
                                              isCompleted: false)
        Group {
            EditGoalView(goalToEdit: sampleGoalWithStartDate) { updatedGoal in
                print("Preview (With Start Date): Goal saved - \(updatedGoal.title), Start: \(String(describing: updatedGoal.startDate))")
            }
            .previewDisplayName("Editing Goal With Start Date")

            EditGoalView(goalToEdit: sampleGoalWithoutStartDate) { updatedGoal in
                print("Preview (No Start Date): Goal saved - \(updatedGoal.title), Start: \(String(describing: updatedGoal.startDate))")
            }
            .previewDisplayName("Editing Goal Without Start Date")
        }
    }
}
