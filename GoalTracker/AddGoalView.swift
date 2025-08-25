//
//  AddGoalView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//

import SwiftUI

struct AddGoalView: View {
    @Binding var goals: [Goal]
    @Binding var showingAddGoal: Bool
    var onGoalAdded: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var newGoalTitle: String = ""
    @State private var newGoalDueDate: Date = Date()
    @State private var newGoalTargetCheckIns: Int = 30
    @State private var includeStartDate: Bool = false
    @State private var selectedStartDate: Date = Date()
    @State private var reminderIsEnabled: Bool = false
    @State private var reminderDate: Date = Date()
    @State private var selectedCadence: GoalCadence = .daily
    @State private var selectedCategoryID: UUID?
    @State private var selectedPresetID: UUID?
    @State private var selectedIconName: String? = "target"
    @State private var showingIconPicker = false
    
    private var selectedCategory: GoalCategory? {
        GoalLibrary.categories.first { $0.id == selectedCategoryID }
    }
    
    private var isSaveDisabled: Bool {
        newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                goalDetailsSection
                categorySection
                datesSection
                schedulingSection
                trackingSection
            }
            .onChange(of: selectedCategoryID) { selectedPresetID = nil }
            .onChange(of: selectedPresetID) {
                guard let presetID = selectedPresetID else {
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
        if !newGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let newGoal = Goal(
                title: newGoalTitle,
                startDate: includeStartDate ? selectedStartDate : nil,
                dueDate: newGoalDueDate,
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
}

private extension AddGoalView {
    // --- VIEW COMPONENTS (Sections) ---
    var goalDetailsSection: some View {
        Section(header: Text("addGoal.section.details")) {
            HStack {
                Button {
                    showingIconPicker = true
                } label: {
                    Image(systemName: selectedIconName ?? "questionmark.circle.fill")
                        .font(.title3)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.accentColor)
                }
                .accessibilityLabel("Select an icon")
                
                TextField("addGoal.placeholder.goalTitle", text: $newGoalTitle)
            }
            
            if let category = selectedCategory, !category.presets.isEmpty {
                Picker("addGoal.picker.preset", selection: $selectedPresetID) {
                    Text("common.none").tag(nil as UUID?)
                    ForEach(category.presets) { preset in
                        Text(LocalizedStringKey(preset.title)).tag(preset.id as UUID?)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
    
    var categorySection: some View {
        Section {
            Picker("addGoal.picker.category", selection: $selectedCategoryID) {
                Text("common.none").tag(nil as UUID?)
                ForEach(GoalLibrary.categories) { category in
                    Label(LocalizedStringKey(category.name), systemImage: category.iconName)
                        .tag(category.id as UUID?)
                }
            }
        }
    }
    
    var datesSection: some View {
        Section(header: Text("addGoal.section.dates")) {
            Toggle("addGoal.toggle.setStartDate", isOn: $includeStartDate.animation())
            if includeStartDate {
                DatePicker("addGoal.datePicker.startDate", selection: $selectedStartDate, in: ...newGoalDueDate, displayedComponents: .date)
            }
            DatePicker("addGoal.datePicker.dueDate", selection: $newGoalDueDate, in: (includeStartDate ? selectedStartDate : Date())..., displayedComponents: .date)
        }
    }
    
    var schedulingSection: some View {
        Section(header: Text("addGoal.section.scheduling")) {
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
    
    var trackingSection: some View {
        Section(header: Text("addGoal.section.trackingMethod")) {
            let formatString = NSLocalizedString("addGoal.stepper.targetCheckins", comment: "")
            Stepper(String(format: formatString, newGoalTargetCheckIns), value: $newGoalTargetCheckIns, in: 1...365)
        }
    }
}
