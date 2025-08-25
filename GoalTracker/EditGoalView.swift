//
//  EditGoalView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/26.
//

// In EditGoalView.swift

import SwiftUI

struct EditGoalView: View {
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

    var body: some View {
        NavigationView {
            Form {
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
                        }
                    }
                }
                
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
        }
    }
}


#Preview {
    // A helper struct is needed to create a @State binding for the preview
    struct PreviewWrapper: View {
        @State private var sampleGoal = Goal(
            title: "My Editable Goal",
            dueDate: Date()
        )
        
        var body: some View {
            EditGoalView(goal: $sampleGoal)
        }
    }
    
    return PreviewWrapper()
}
