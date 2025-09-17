//
//  AddGoalView.swift
//  GoalTracker
//
<<<<<<< HEAD
//  Created by AJ on 2025/05/19.
//

=======
//  Created by AJ on 2025/04/14.
//

// In AddGoalView.swift

// In AddGoalView.swift
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
import SwiftUI

struct AddGoalView: View {
    @Binding var goals: [Goal]
    @Binding var showingAddGoal: Bool
<<<<<<< HEAD
    var onGoalAdded: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
=======

    // State for the new goal's properties
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
    @State private var newGoalTitle: String = ""
    @State private var newGoalDueDate: Date = Date()
    @State private var newGoalTargetCheckIns: Int = 30
    @State private var includeStartDate: Bool = false
    @State private var selectedStartDate: Date = Date()
<<<<<<< HEAD
    @State private var reminderIsEnabled: Bool = false
    @State private var reminderDate: Date = Date()
    @State private var selectedCadence: GoalCadence = .daily
    @State private var selectedCategoryID: UUID?
    @State private var selectedPresetID: UUID?
    @State private var selectedIconName: String? = "target"
    @State private var showingIconPicker = false
    @State private var newGoalCompletionPercentage: Double = 0.0
    
    private var selectedCategory: GoalCategory? {
        GoalLibrary.categories.first { $0.id == selectedCategoryID }
    }
    
    private var isSaveDisabled: Bool {
        newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
=======
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
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
    }

    var body: some View {
        NavigationView {
            Form {
<<<<<<< HEAD
                goalDetailsSection
                categorySection
                datesSection
                schedulingSection
                trackingSection
                initialProgressSection
            }
            .onChange(of: selectedCategoryID) { _, _ in selectedPresetID = nil }
            .onChange(of: selectedPresetID) { _, newValue in
                guard let presetID = newValue else {
                    newGoalTitle = ""
                    return
                }
                if let preset = selectedCategory?.presets.first(where: { $0.id == presetID }) {
                    let localizedTemplate = NSLocalizedString(preset.template, comment: "")
                    newGoalTitle = localizedTemplate
                }
            }
            .navigationTitle("addGoal.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("common.cancel") { showingAddGoal = false } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("common.save") { saveGoal() }
                        .disabled(isSaveDisabled)
                }
            }
            .sheet(isPresented: $showingIconPicker) {
                IconPickerView(selectedIconName: $selectedIconName)
            }
        }
    }
    
    private func saveGoal() {
        
        print("--- Saving goal with iconName: \(self.selectedIconName ?? "nil") ---")
                
        
        if !newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let newGoal = Goal(
                title: newGoalTitle,
                startDate: includeStartDate ? selectedStartDate : nil,
                dueDate: newGoalDueDate,
                completionPercentage: newGoalCompletionPercentage,
                targetCheckIns: newGoalTargetCheckIns,
                reminderIsEnabled: self.reminderIsEnabled,
                reminderDate: self.reminderDate,
                cadence: self.selectedCadence,
                categoryID: self.selectedCategoryID,
                iconName: self.selectedIconName
            )
            goals.append(newGoal)
            onGoalAdded()
            showingAddGoal = false
        }
    }
    
    private var goalDetailsSection: some View {
        Section(header: Text("addGoal.section.details")) {
            HStack {
                Button { showingIconPicker = true } label: {
                    Image(systemName: selectedIconName ?? "questionmark.circle.fill")
                        .font(.title3).frame(width: 30, height: 30).foregroundStyle(Color.accentColor)
                }.accessibilityLabel("Select an icon")
                
                TextField("addGoal.placeholder.goalTitle", text: $newGoalTitle)
            }
            
            if let category = selectedCategory, !category.presets.isEmpty {
                Picker("addGoal.picker.preset", selection: $selectedPresetID) {
                    Text("common.none").tag(nil as UUID?)
                    ForEach(category.presets) { preset in
                        Text(LocalizedStringKey(preset.title)).tag(preset.id as UUID?)
                    }
                }.pickerStyle(.menu)
            }
        }
    }
    
    private var categorySection: some View {
        Section {
            Picker("addGoal.picker.category", selection: $selectedCategoryID) {
                Text("common.none").tag(nil as UUID?)
                ForEach(GoalLibrary.categories) { category in
                    HStack {
                        Image(systemName: category.iconName)
                            .renderingMode(.original)
                            .foregroundStyle(color(for: category.colorName))
                        Text(LocalizedStringKey(category.name))
                    }.tag(category.id as UUID?)
                }
            }.pickerStyle(.menu)
        }
    }
    
    private func color(for name: String) -> Color {
        switch name {
        case "green": return .green
        case "red": return .red
        case "blue": return .blue
        default: return .primary
        }
    }
    
    private var datesSection: some View {
        Section(header: Text("addGoal.section.dates")) {
            Toggle("addGoal.toggle.setStartDate", isOn: $includeStartDate.animation())
            if includeStartDate {
                DatePicker("addGoal.datePicker.startDate", selection: $selectedStartDate, in: ...newGoalDueDate, displayedComponents: .date)
            }
            DatePicker("addGoal.datePicker.dueDate", selection: $newGoalDueDate, in: (includeStartDate ? selectedStartDate : Date())..., displayedComponents: .date)
        }
    }
    
    private var schedulingSection: some View {
        Section(header: Text("addGoal.section.frequency")) {
            Picker("addGoal.picker.trackStreak", selection: $selectedCadence) {
                ForEach(GoalCadence.allCases) { cadence in
                    Text(cadence.localizedKey).tag(cadence)
                }
            }
            
            Toggle("addGoal.toggle.setReminder", isOn: $reminderIsEnabled.animation())
            if reminderIsEnabled {
                DatePicker("addGoal.datePicker.remindMeAt", selection: $reminderDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
            }
        }
    }
    
    private var trackingSection: some View {
        Section(header: Text("addGoal.section.trackingMethod")) {
            let formatString = NSLocalizedString("addGoal.stepper.targetCheckins", comment: "")
            Stepper(String(format: formatString, newGoalTargetCheckIns), value: $newGoalTargetCheckIns, in: 1...365)
        }
    }
    
    private var initialProgressSection: some View {
        Section(header: Text("addGoal.section.initialProgress")) {
            VStack(alignment: .leading) {
                let formatString = NSLocalizedString("addGoal.text.percentage", comment: "")
                Text(String(format: formatString, Int(newGoalCompletionPercentage * 100)))
                Slider(value: $newGoalCompletionPercentage, in: 0...1, step: 0.01)
            }
=======
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
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
        }
    }
}

<<<<<<< HEAD

#Preview {
    struct PreviewHost: View {
        @State private var goals: [Goal] = []
        @State private var showingAddGoal = true

        var body: some View {
            VStack {}
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(
                    goals: $goals,
                    showingAddGoal: $showingAddGoal,
=======
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
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                    onGoalAdded: {
                        print("Preview: Goal added! Total goals: \(goals.count)")
                    }
                )
            }
        }
    }
<<<<<<< HEAD
    
    return PreviewHost()
=======
    // End of helper struct definition

    // Use the helper struct in the previews
    static var previews: some View {
        PreviewHost() // Instantiate helper struct here.
    }
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
}
