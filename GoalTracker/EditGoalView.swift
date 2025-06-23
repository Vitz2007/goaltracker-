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
    
    @Binding var goal: Goal
    
    // State variable for debug UI
    @State private var fakeCheckInDate: Date = Date()
    

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Goal Title", text: $goal.title)
                }
                
                Section(header: Text("Progress")) {
                    VStack(alignment: .leading) {
                        Text("Completion: \(Int(goal.completionPercentage * 100))%")
                        Slider(value: $goal.completionPercentage, in: 0...1, step: 0.01)
                    }
                }
                
                Section(header: Text("Dates")) {
                    Toggle("Set a Start Date", isOn: Binding(get: { goal.startDate != nil }, set: { hasStartDate in
                        if hasStartDate {
                            goal.startDate = goal.startDate ?? Date()
                        } else {
                            goal.startDate = nil
                        }
                    }).animation())
                    
                    if goal.startDate != nil {
                        DatePicker("Start Date",
                                 selection: Binding(get: { goal.startDate ?? Date() }, set: { goal.startDate = $0 }),
                                 in: ...(goal.dueDate ?? .distantFuture),
                                 displayedComponents: .date)
                    }
                    
                    DatePicker("Deadline",
                               selection: Binding(get: { goal.dueDate ?? Date() }, set: { goal.dueDate = $0 }),
                               in: (goal.startDate ?? .distantPast)...,
                               displayedComponents: .date)
                }
                
                Section(header: Text("Frequency")) {
                    Picker("Track Streak", selection: $goal.cadence) {
                        ForEach(GoalCadence.allCases) { cadence in
                            Text(cadence.rawValue).tag(cadence)
                        }
                    }
                }
                
                Section(header: Text("Reminder")) {
                    Toggle("Set a Reminder", isOn: $goal.reminderIsEnabled.animation())
                    
                    if goal.reminderIsEnabled {
                        DatePicker("Remind Me At",
                                   selection: $goal.reminderDate,
                                   in: Date()...,
                                   displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Tracking Method")) {
                    Stepper("Target Check-ins: \(goal.targetCheckIns)", value: $goal.targetCheckIns, in: 1...365)
                }
                
                // --- ADDING THE DEBUG SECTION BACK IN ---
                                Section(header: Text("Debug: Fake Check-ins")) {
                                    if !goal.checkIns.isEmpty {
                                        ForEach(goal.checkIns) { checkIn in
                                            Text("Checked in on: \(checkIn.date, style: .date)")
                                        }
                                        .onDelete { indexSet in
                                            goal.checkIns.remove(atOffsets: indexSet)
                                        }
                                    }
                                    DatePicker("Fake Check-in Date", selection: $fakeCheckInDate, displayedComponents: .date)
                                    Button("Add Fake Check-in") {
                                        let newCheckIn = CheckInRecord(date: fakeCheckInDate)
                                        goal.checkIns.append(newCheckIn)
                                        goal.checkIns.sort(by: { $0.date > $1.date })
                                    }
                                }
                
            }
            .navigationTitle("Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if goal.reminderIsEnabled {
                            NotificationManager.scheduleNotification(for: goal)
                        } else {
                            NotificationManager.cancelNotification(for: goal)
                        }
                        dismiss()
                    }
                    .disabled(goal.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}


// Updated  EditGoalView_Previews to work without the onSave closure
struct EditGoalView_Previews: PreviewProvider {
    struct PreviewHost: View {
        @State private var sampleGoal = Goal(title: "Preview Goal")
        var body: some View {
            EditGoalView(goal: $sampleGoal)
        }
    }
    
    static var previews: some View {
        PreviewHost()
    }
}
