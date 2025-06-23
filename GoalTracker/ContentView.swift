//
//  ContentView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/07.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var goals: [Goal] = []
    @State private var showingAddGoal = false
    @State private var showingSettings = false
    @State private var path = NavigationPath()

    @State private var currentSortOrder: SortOrder = .byCreationDate
    @State private var currentFilter: GoalFilter = .active
    
    // Accessing the shared settings object
    @State private var appSettings = AppSettings.shared

    private var filteredAndSortedGoals: [Goal] {
        let filtered: [Goal]
        switch currentFilter {
        case .all:
            filtered = goals
        case .active:
            filtered = goals.filter { !$0.isCompleted }
        }
        
        switch currentSortOrder {
        case .byTitle:
            return filtered.sorted { $0.title.lowercased() < $1.title.lowercased() }
        case .byDueDate:
            return filtered.sorted { (goal1, goal2) in
                switch (goal1.dueDate, goal2.dueDate) {
                case (let date1?, let date2?): return date1 < date2
                case (nil, _): return false
                case (_, nil): return true
                }
            }
        case .byCreationDate:
            return filtered.sorted { (goal1, goal2) in
                switch (goal1.startDate, goal2.startDate) {
                case (let date1?, let date2?): return date1 > date2
                case (nil, _): return false
                case (_, nil): return true
                }
            }
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if goals.isEmpty {
                    EmptyStateView()
                        .frame(maxHeight: .infinity)
                } else {
                    // The List now useing a simpler ForEach loop
                    List {
                        ForEach(filteredAndSortedGoals) { goal in
                            // Call new helper function to build the row
                            row(for: goal)
                        }
                        .onDelete(perform: deleteGoal)
                    }
                    .listStyle(.plain)
                }

                if !goals.isEmpty {
                    Spacer()
                }

                AddGoalButtonView {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.prepare()
                    generator.impactOccurred()
                    showingAddGoal = true
                }
            }
            .navigationTitle("My Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Sort By", selection: $currentSortOrder) {
                            ForEach(SortOrder.allCases) { order in
                                Text(order.rawValue).tag(order)
                            }
                        }
                        
                        Picker("Filter", selection: $currentFilter) {
                            ForEach(GoalFilter.allCases) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                        
                        // Divider to separate the sections visually
                        Divider()
                                    
                        // New button to open the Settings screen
                        Button {
                            showingSettings = true
                        } label: {
                            // A Label gives us both an icon and text, perfect for a menu item.
                                Text("Settings")
                            }
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .onChange(of: goals, { saveGoals() })
            .navigationDestination(for: Goal.self) { goal in
                if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                    GoalDetailView(
                        goal: $goals[index],
                        onDelete: { id in
                            deleteGoal(id: id)
                            if !path.isEmpty {
                                path.removeLast()
                            }
                        }
                    )
                }
            }
            
            // Adding new sheet for settings
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(goals: $goals, showingAddGoal: $showingAddGoal, onGoalAdded: saveGoals)
            }
            .onAppear {
                requestNotificationPermission()
                loadGoals()
            }
        }
    }
    
    // Simplifying the ForEach loop
    @ViewBuilder
    private func row(for goal: Goal) -> some View {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            NavigationLink(value: goal) {
                GoalRowView(goal: $goals[index], settings: self.appSettings) {
                    if !$goals[index].wrappedValue.isCompleted {
                        NotificationManager.cancelNotification(for: $goals[index].wrappedValue)
                    }
                    goals[index].isCompleted.toggle()
                }
            }
        }
    }

    // Functions
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func deleteGoal(at offsets: IndexSet) {
        let goalsToDelete = offsets.map { filteredAndSortedGoals[$0] }
        for goal in goalsToDelete {
            NotificationManager.cancelNotification(for: goal)
        }
        let idsToDelete = Set(goalsToDelete.map { $0.id })
        goals.removeAll { idsToDelete.contains($0.id) }
    }
    
    func deleteGoal(id: UUID) {
        if let goalToDelete = goals.first(where: { $0.id == id }) {
            NotificationManager.cancelNotification(for: goalToDelete)
        }
        goals.removeAll { $0.id == id }
    }

    func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: "savedGoals")
        }
    }

    func loadGoals() {
        if let savedGoalsData = UserDefaults.standard.data(forKey: "savedGoals") {
            if let decodedGoals = try? JSONDecoder().decode([Goal].self, from: savedGoalsData) {
                goals = decodedGoals
                return
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
