//
//  EditGoalView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/26.
//

// In EditGoalView.swift

import SwiftUI

struct EditGoalView: View {
<<<<<<< HEAD
    @Binding var goal: Goal
    @Environment(\.dismiss) private var dismiss

    // Local state to hold edits for every editable property
    @State private var localTitle: String
    @State private var localDueDate: Date
    @State private var localIncludeStartDate: Bool
    @State private var localStartDate: Date
    @State private var localCadence: GoalCadence
    @State private var localReminderIsEnabled: Bool
    @State private var localReminderDate: Date
    @State private var localTargetCheckIns: Int
    @State private var localIconName: String?
    @State private var localCategoryID: UUID?
    
    @State private var showingIconPicker = false

    private var selectedCategory: GoalCategory? {
        GoalLibrary.categories.first { $0.id == localCategoryID }
    }
    
    private var isSaveDisabled: Bool {
        localTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // Initializer to copy the goal's data into the local state
    init(goal: Binding<Goal>) {
        self._goal = goal
        let g = goal.wrappedValue
        self._localTitle = State(initialValue: g.title)
        self._localDueDate = State(initialValue: g.dueDate ?? Date())
        self._localIncludeStartDate = State(initialValue: g.startDate != nil)
        self._localStartDate = State(initialValue: g.startDate ?? Date())
        self._localCadence = State(initialValue: g.cadence)
        self._localReminderIsEnabled = State(initialValue: g.reminderIsEnabled)
        self._localReminderDate = State(initialValue: g.reminderDate)
        self._localTargetCheckIns = State(initialValue: g.targetCheckIns)
        self._localIconName = State(initialValue: g.iconName)
        self._localCategoryID = State(initialValue: g.categoryID)
    }
=======
    @Environment(\.dismiss) var dismiss
    
    @Binding var goal: Goal
    
    // State variable for debug UI
    @State private var fakeCheckInDate: Date = Date()
    
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484

    var body: some View {
        NavigationView {
            Form {
<<<<<<< HEAD
                Section(header: Text("editGoal.section.details")) {
                    HStack {
                        Button {
                            showingIconPicker = true
                        } label: {
                            Image(systemName: localIconName ?? "questionmark.circle.fill")
                                .font(.title3)
                                .frame(width: 30, height: 30)
                                .foregroundStyle(Color.accentColor)
                        }
                        .accessibilityLabel("Select an icon")
                        
                        TextField("editGoal.placeholder.goalTitle", text: $localTitle)
                    }
                }

                Section {
                    Picker("addGoal.picker.category", selection: $localCategoryID) {
                        Text("common.none").tag(nil as UUID?)
                        ForEach(GoalLibrary.categories) { category in
                            Label(LocalizedStringKey(category.name), systemImage: category.iconName)
                                .tag(category.id as UUID?)
                        }
                    }
                }

                Section(header: Text("addGoal.section.dates")) {
                    Toggle("addGoal.toggle.setStartDate", isOn: $localIncludeStartDate.animation())
                    if localIncludeStartDate {
                        DatePicker("addGoal.datePicker.startDate", selection: $localStartDate, in: ...localDueDate, displayedComponents: .date)
                    }
                    DatePicker("addGoal.datePicker.dueDate", selection: $localDueDate, in: (localIncludeStartDate ? localStartDate : Date())..., displayedComponents: .date)
                }

                Section(header: Text("addGoal.section.frequency")) {
                    Picker("addGoal.picker.trackStreak", selection: $localCadence) {
                        ForEach(GoalCadence.allCases) { cadence in
                            Text(cadence.localizedKey).tag(cadence)
=======
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
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                        }
                    }
                }
                
<<<<<<< HEAD
                Section(header: Text("addGoal.section.reminder")) {
                    Toggle("addGoal.toggle.setReminder", isOn: $localReminderIsEnabled.animation())
                    if localReminderIsEnabled {
                        DatePicker("addGoal.datePicker.remindMeAt", selection: $localReminderDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("addGoal.section.trackingMethod")) {
                    let formatString = NSLocalizedString("addGoal.stepper.targetCheckins", comment: "")
                    Stepper(String(format: formatString, localTargetCheckIns), value: $localTargetCheckIns, in: 1...365)
                }
            }
            .navigationTitle("editGoal.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("common.done") {
                        // Copy all local changes back to the original goal
                        goal.title = localTitle
                        goal.dueDate = localDueDate
                        goal.startDate = localIncludeStartDate ? localStartDate : nil
                        goal.cadence = localCadence
                        goal.reminderIsEnabled = localReminderIsEnabled
                        goal.reminderDate = localReminderDate
                        goal.targetCheckIns = localTargetCheckIns
                        goal.iconName = localIconName
                        goal.categoryID = localCategoryID
                        
                        dismiss()
                    }
                    .disabled(isSaveDisabled)
                }
            }
            .sheet(isPresented: $showingIconPicker) {
                IconPickerView(selectedIconName: $localIconName)
            }
=======
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
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
        }
    }
}


<<<<<<< HEAD
#Preview {
    // A helper struct is needed to create a @State binding for the preview
    struct PreviewWrapper: View {
        @State private var sampleGoal = Goal(
            title: "My Editable Goal",
            dueDate: Date()
        )
        
=======
// Updated  EditGoalView_Previews to work without the onSave closure
struct EditGoalView_Previews: PreviewProvider {
    struct PreviewHost: View {
        @State private var sampleGoal = Goal(title: "Preview Goal")
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
        var body: some View {
            EditGoalView(goal: $sampleGoal)
        }
    }
    
<<<<<<< HEAD
    return PreviewWrapper()
=======
    static var previews: some View {
        PreviewHost()
    }
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
}
