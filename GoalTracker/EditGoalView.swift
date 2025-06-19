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
    
    // Local copy of the goal to be edited.
    @State private var goalToEdit: Goal
    var onSave: (Goal) -> Void
    
    // State for managing optional start date UI
    @State private var includeStartDate: Bool
    
    // new state vars added for the reminder
    @State private var reminderIsEnabled: Bool
    @State private var reminderDate: Date

    // Custom initializer to set up the @State properties
    init(goalToEdit: Goal, onSave: @escaping (Goal) -> Void) {
        // Using _goalToEdit to set the initial value of the @State wrapper
        self._goalToEdit = State(initialValue: goalToEdit)
        self.onSave = onSave
        
        // Initialize state for the start date toggle
        if let _ = goalToEdit.startDate {
            self._includeStartDate = State(initialValue: true)
        } else {
            self._includeStartDate = State(initialValue: false)
        }
        
        // Initialize new reminder state
        self._reminderIsEnabled = State(initialValue: goalToEdit.reminderIsEnabled)
        self._reminderDate = State(initialValue: goalToEdit.reminderDate)
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
                        Slider(value: $goalToEdit.completionPercentage, in: 0...1, step: 0.01)
                    }
                }
                
                Section(header: Text("Dates")) {
                    // Leave Start and Due dates as is because complex
                    // Add the new section below
                    Toggle("Set a Start Date", isOn: $includeStartDate.animation())
                    if includeStartDate {
                        DatePicker("Start Date",
                                 selection: Binding(get: { goalToEdit.startDate ?? Date() }, set: { goalToEdit.startDate = $0 }),
                                 in: ...(goalToEdit.dueDate ?? .distantFuture),
                                 displayedComponents: .date)
                    }
                    
                    DatePicker("Deadline",
                               selection: Binding(get: { goalToEdit.dueDate ?? Date() }, set: { goalToEdit.dueDate = $0 }),
                               in: (goalToEdit.startDate ?? .distantPast)...,
                               displayedComponents: .date)
                }
                
                // Adding new reminder section below
                Section(header: Text("Reminder")) {
                    Toggle("Set a Reminder", isOn: $reminderIsEnabled.animation())
                    
                    if reminderIsEnabled {
                        DatePicker("Remind Me At",
                                   selection: $reminderDate,
                                   in: Date()..., // Ensures reminder is not set in the past
                                   displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Tracking Method")) {
                    Stepper("Target Check-ins: \(goalToEdit.targetCheckIns)", value: $goalToEdit.targetCheckIns, in: 1...365)
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
                        // Update save logic
                        
                        // Update goal object with latest reminder settings
                        goalToEdit.reminderIsEnabled = self.reminderIsEnabled
                        goalToEdit.reminderDate = self.reminderDate
                        
                        // Schedule or cancel the notification
                        if goalToEdit.reminderIsEnabled {
                            // Works for both new and updated reminders.
                            NotificationManager.scheduleNotification(for: goalToEdit)
                        } else {
                            // If toggle was turned off, cancel any old notification.
                            NotificationManager.cancelNotification(for: goalToEdit)
                        }
                        
                        // Save goal and dismiss the view
                        onSave(goalToEdit)
                        dismiss()
                    }
                    .disabled(goalToEdit.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// Updated preview provider
struct EditGoalView_Previews: PreviewProvider {
    static var previews: some View {
        // Goal initializers now need the reminder properties
        let sampleGoalWithStartDate = Goal(
            title: "Fitness Challenge",
            startDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()),
            dueDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
            isCompleted: false,
            reminderIsEnabled: true,
            reminderDate: Date()
        )
        
        let sampleGoalWithoutStartDate = Goal(
            title: "Read New Book",
            startDate: nil,
            dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date()),
            isCompleted: false,
            reminderIsEnabled: false,
            reminderDate: Date()
        )
        
        Group {
            EditGoalView(goalToEdit: sampleGoalWithStartDate) { updatedGoal in
                print("Preview: Goal saved - \(updatedGoal.title)")
            }
            .previewDisplayName("Editing Goal With Reminder")
            
            EditGoalView(goalToEdit: sampleGoalWithoutStartDate) { updatedGoal in
                print("Preview: Goal saved - \(updatedGoal.title)")
            }
            .previewDisplayName("Editing Goal Without Reminder")
        }
    }
}
