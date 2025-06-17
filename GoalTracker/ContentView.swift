//
//  ContentView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/07.
//

import SwiftUI

// Adding additional import
import UserNotifications

struct ContentView: View {
    @State private var goals: [Goal] = []
    @State private var showingAddGoal = false
    @State private var path = NavigationPath()

    // State variables for sorting and filtering
    @State private var currentSortOrder: SortOrder = .byCreationDate
    @State private var currentFilter: GoalFilter = .active

    // Display logic for all single computed property
    private var filteredAndSortedGoals: [Goal] {
        // Applying the filter
        let filtered: [Goal]
        switch currentFilter {
        case .all:
            filtered = goals
        case .active:
            filtered = goals.filter { !$0.isCompleted }
        }
        
        // 2. Applying sort order
        switch currentSortOrder {
        case .byTitle:
            return filtered.sorted { $0.title.lowercased() < $1.title.lowercased() }
        case .byDueDate:
            return filtered.sorted { (goal1, goal2) in
                // Handle cases where one or both due dates might be nil
                switch (goal1.dueDate, goal2.dueDate) {
                case (let date1?, let date2?):
                    // When both dates exist, compare them directly.
                    return date1 < date2
                case (nil, _):
                    // If the first goal's date is nil, it should go proceed the second.
                    return false
                case (_, nil):
                    // If the second goal's date is nil, it should go after the first.
                    return true
                }
            }
        case .byCreationDate:
            return filtered.sorted { (goal1, goal2) in
                // Handle cases where one or both start dates might be nil
                switch (goal1.startDate, goal2.startDate) {
                case (let date1?, let date2?):
                    // If both dates exist, sort newest first.
                    return date1 > date2
                case (nil, _):
                    // If the first goal's date is nil, it should proceed the second.
                    return false
                case (_, nil):
                    // If the second goal's date is nil, it should go after the first.
                    return true
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
                    // List uses new smart property ---
                    // Deleted sectioning while sorting adds a lot of complexity.
                    List {
                        ForEach(filteredAndSortedGoals) { goal in
                            if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                                NavigationLink(value: goal) {
                                    GoalRowView(goal: $goals[index]) {
                                        goals[index].isCompleted.toggle()
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteGoal) // Simplified delete
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
            
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(goals: $goals, showingAddGoal: $showingAddGoal, onGoalAdded: saveGoals)
            }
            .onAppear {
                requestNotificationPermission()
                loadGoals()
            }
        }
    }
    
    // Adding request notification function
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
            print("Notification permission granted.")
        } else if let error = error {
            print(error.localizedDescription)
          }
        }
    }

    // Functions
    // Simplified delete function for swipe-to-delete
    func deleteGoal(at offsets: IndexSet) {
        let goalsToDelete = offsets.map { filteredAndSortedGoals[$0] }
        let idsToDelete = Set(goalsToDelete.map { $0.id })
        goals.removeAll { idsToDelete.contains($0.id) }
    }
    
    func deleteGoal(id: UUID) {
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
