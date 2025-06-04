//
//  AddGoalView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/14.
//

// In AddGoalView.swift
import SwiftUI

struct AddGoalView: View {
    @Binding var goals: [Goal]
    @Binding var showingAddGoal: Bool

    // State for the new goal's properties
    @State private var newGoalTitle: String = ""
    @State private var newGoalDueDate: Date = Date()
    @State private var newGoalTargetCheckIns: Int = 30

    // New state variables for optional start date and completion percentage
    @State private var includeStartDate: Bool = false
    @State private var selectedStartDate: Date = Date() // Default if user toggles it on
    @State private var newGoalCompletionPercentage: Double = 0.0 // Defaults to 0%

    var onGoalAdded: () -> Void // Closure to trigger saving in ContentView
    @Environment(\.dismiss) var dismiss

    // Computed property to define the valid range for the due date picker
    private var dueDateRange: PartialRangeFrom<Date> { // << Updated revised TYPE
        let SDate = Calendar.current.startOfDay(for: includeStartDate ? selectedStartDate : Date())
        return SDate...
    }
    
    // Computed property for start date range (can't be after due date)
    private var startDateRange: PartialRangeThrough<Date> {
        // If due date is set, start date can't be after it.
        // Otherwise, allow any past or present date.
        return ...newGoalDueDate
    }


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Goal Title", text: $newGoalTitle)
                }

                Section(header: Text("Dates")) {
                    // Optional Start Date
                    Toggle("Set a Start Date", isOn: $includeStartDate.animation())
                    if includeStartDate {
                        DatePicker("Start Date",
                                   selection: $selectedStartDate,
                                   in: startDateRange, // Start date can be up to the due date
                                   displayedComponents: .date)
                    }

                    // Due Date
                    DatePicker("Due Date",
                               selection: $newGoalDueDate,
                               in: dueDateRange, // Due date must be on or after start date (or today)
                               displayedComponents: .date)
                }
                
                Section(header: Text("Tracking Method")) {
                    Stepper("Target Check-ins: \(newGoalTargetCheckIns)",
                            value: $newGoalTargetCheckIns,
                            in: 1...365) // Example range here
                }

                // --- New section for initial progress ---
                Section(header: Text("Initial Progress (Optional)")) {
                    VStack(alignment: .leading) {
                        Text("Percentage: \(Int(newGoalCompletionPercentage * 100))%")
                        Slider(value: $newGoalCompletionPercentage, in: 0...1, step: 0.01)
                    }
                }
                // --- End of new section ---

                Button("Add Goal") {
                    if !newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        let newGoal = Goal(
                            title: newGoalTitle,
                            startDate: includeStartDate ? selectedStartDate : nil, // Use selected start date if included
                            dueDate: newGoalDueDate,
                            isCompleted: (newGoalCompletionPercentage == 1.0), // Auto-complete if 100%
                            completionPercentage: newGoalCompletionPercentage, // Set initial percentage
                            targetCheckIns: newGoalTargetCheckIns
                            // checkIns will always default to empty as per Goal model
                        )
                        goals.append(newGoal)
                        onGoalAdded()
                        showingAddGoal = false
                        // dismiss() // or use dismiss here
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Add New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingAddGoal = false
                        // dismiss()
                    }
                }
            }
        }
    }
}

// Preview for AddGoalView (ensure it works with all the bindings)
// In AddGoalView.swift

// AddGoalView struct definition needs to be above this

struct AddGoalView_Previews: PreviewProvider {

    // --- Defining helper struct below (if not already defined elsewhere)
    
    struct PreviewHost: View {
        @State private var goals: [Goal] = [] // State for the goals binding
        @State private var showingAddGoal = true // State for the showingAddGoal binding
                                                // Set true if want to see the sheet immediately.

        var body: some View {
            // VStack for a placeholder to host the .sheet modifier.
            // Contents not very visible if the sheet is always presented.
            VStack {
                Text("Previewing AddGoalView Sheet...")
                    .opacity(0) // Make it invisible if we only care about the sheet
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(
                    goals: $goals, // Pass the binding
                    showingAddGoal: $showingAddGoal, // Pass the binding
                    onGoalAdded: {
                        print("Preview: Goal added! Total goals: \(goals.count)")
                    }
                )
            }
        }
    }
    // --- End of helper struct definition ---

    // Use the helper struct in the previews
    static var previews: some View {
        PreviewHost() // Instantiate helper struct here.
    }
}
