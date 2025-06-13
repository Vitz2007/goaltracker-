//
//  ContentView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/07.
//

import SwiftUI

struct ContentView: View {
    @State private var goals: [Goal] = []
    @State private var showingAddGoal = false
    @State private var path = NavigationPath()

    // State variables for sorting and filtering
    @State private var currentSortOrder: SortOrder = .byCreationDate
    @State private var currentFilter: GoalFilter = .active

    private var activeGoals: [Goal] {
        goals.filter { !$0.isCompleted }
    }

    private var completedGoals: [Goal] {
        goals.filter { $0.isCompleted }
    }
    
    var goalListView: some View {
        List {
            Section(header: Text("Active").font(.headline).foregroundColor(.primary)) {
                ForEach(activeGoals) { goal in
                    if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                        NavigationLink(value: goal) {
                            GoalRowView(goal: $goals[index]) {
                                goals[index].isCompleted.toggle()
                            }
                        }
                    }
                }
                .onDelete(perform: deleteActiveGoal)
            }
            
            if !completedGoals.isEmpty {
                Section(header: Text("Completed").font(.headline).foregroundColor(.primary)) {
                    ForEach(completedGoals) { goal in
                        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                            NavigationLink(value: goal) {
                                GoalRowView(goal: $goals[index]) {
                                    goals[index].isCompleted.toggle()
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteCompletedGoal)
                }
            }
        }
        .listStyle(.plain)
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if goals.isEmpty {
                    EmptyStateView()
                        .frame(maxHeight: .infinity)
                } else {
                    // Call our simple 'goalListView' property.
                    goalListView
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
            .onChange(of: goals) {
                saveGoals()
            }
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
            .onAppear(perform: loadGoals)
        }
    }

    // --- Functions ---
    func deleteGoal(id: UUID) {
        goals.removeAll { $0.id == id }
    }

    func deleteActiveGoal(at offsets: IndexSet) {
        let goalsToDelete = offsets.map { activeGoals[$0] }
        let idsToDelete = goalsToDelete.map { $0.id }
        goals.removeAll { idsToDelete.contains($0.id) }
    }
    
    func deleteCompletedGoal(at offsets: IndexSet) {
        let goalsToDelete = offsets.map { completedGoals[$0] }
        let idsToDelete = goalsToDelete.map { $0.id }
        goals.removeAll { idsToDelete.contains($0.id) }
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
