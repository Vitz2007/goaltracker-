//
//  AddGoalView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/14.
//

// In AddGoalView.swift

// In AddGoalView.swift
import SwiftUI

struct AddGoalView: View {
    @Binding var goals: [Goal]
    @Binding var showingAddGoal: Bool

    // State for the new goal's properties
    @State private var newGoalTitle: String = ""
    @State private var newGoalDueDate: Date = Date()
    @State private var newGoalTargetCheckIns: Int = 30
    @State private var includeStartDate: Bool = false
    @State private var selectedStartDate: Date = Date()
    @State private var newGoalCompletionPercentage: Double = 0.0
    @State private var reminderIsEnabled: Bool = false
    @State private var reminderDate: Date = Date()
    
    // Add new state for cadence
    @State private var selectedCadence: GoalCadence = .daily

    var onGoalAdded: () -> Void
    @Environment(\.dismiss) var dismiss

    // Computed properties for date ranges...
    private var dueDateRange: PartialRangeFrom<Date> {
        let SDate = Calendar.current.startOfDay(for: includeStartDate ? selectedStartDate : Date())
        return SDate...
    }
    private var startDateRange: PartialRangeThrough<Date> {
        return ...newGoalDueDate
    }
    private var reminderDateRange: PartialRangeFrom<Date> {
        return Date()...
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Goal Title", text: $newGoalTitle)
                }

                Section(header: Text("Dates")) {
                    Toggle("Set a Start Date", isOn: $includeStartDate.animation())
                    if includeStartDate {
                        DatePicker("Start Date", selection: $selectedStartDate, in: startDateRange, displayedComponents: .date)
                    }
                    DatePicker("Due Date", selection: $newGoalDueDate, in: dueDateRange, displayedComponents: .date)
                }
                
                // Add new frequency portion
                Section(header: Text("Frequency")) {
                    Picker("Track Streak", selection: $selectedCadence) {
                        ForEach(GoalCadence.allCases) { cadence in
                            Text(cadence.rawValue).tag(cadence)
                        }
                    }
                }
                
                Section(header: Text("Reminder")) {
                    Toggle("Set a Reminder", isOn: $reminderIsEnabled.animation())
                    if reminderIsEnabled {
                        DatePicker("Remind Me At", selection: $reminderDate, in: reminderDateRange, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Tracking Method")) {
                    Stepper("Target Check-ins: \(newGoalTargetCheckIns)", value: $newGoalTargetCheckIns, in: 1...365)
                }

                Section(header: Text("Initial Progress (Optional)")) {
                    VStack(alignment: .leading) {
                        Text("Percentage: \(Int(newGoalCompletionPercentage * 100))%")
                        Slider(value: $newGoalCompletionPercentage, in: 0...1, step: 0.01)
                    }
                }

                Button("Add Goal") {
                    if !newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        // Update goal initializer
                        let newGoal = Goal(
                            title: newGoalTitle,
                            startDate: includeStartDate ? selectedStartDate : nil,
                            dueDate: newGoalDueDate,
                            isCompleted: (newGoalCompletionPercentage == 1.0),
                            completionPercentage: newGoalCompletionPercentage,
                            targetCheckIns: newGoalTargetCheckIns,
                            reminderIsEnabled: self.reminderIsEnabled,
                            reminderDate: self.reminderDate,
                            
                            // Add the selected cadence
                            cadence: self.selectedCadence
                        )
                        goals.append(newGoal)
                        NotificationManager.scheduleNotification(for: newGoal)
                        onGoalAdded()
                        showingAddGoal = false
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Add New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { showingAddGoal = false }
                    // dismiss()
                }
            }
        }
    }
}

// Preview provider remains the same...
// Preview for AddGoalView
// In AddGoalView.swift

// AddGoalView struct definition needs to be above this

struct AddGoalView_Previews: PreviewProvider {

    // Helper struct below
    
    struct PreviewHost: View {
        @State private var goals: [Goal] = [] // State for the goals binding
        @State private var showingAddGoal = true // State for the showingAddGoal binding
                                                // Set true if want to see the sheet immediately.

        var body: some View {
            // VStack for a placeholder to host the .sheet modifier.
            // Contents not visible if the sheet is always presented.
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
    // End of helper struct definition

    // Use the helper struct in the previews
    static var previews: some View {
        PreviewHost() // Instantiate helper struct here.
    }
}
