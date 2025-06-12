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

    // Create a read-only array of the active goals.
    private var activeGoals: [Goal] {
        goals.filter { !$0.isCompleted }
    }

    // Creates a read-only array of the completed goals.
    private var completedGoals: [Goal] {
        goals.filter { $0.isCompleted }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if goals.isEmpty {
                    EmptyStateView()
                        .frame(maxHeight: .infinity)
                } else {
                    
                    List {
                        // For Active Goals
                        Section(header: Text("Active").font(.headline).foregroundColor(.primary)) {
                            ForEach(activeGoals) { goal in
                                // Find the binding to the original goal
                                if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                                    NavigationLink(value: goal) {
                                        GoalRowView(goal: $goals[index]) {
                                            goals[index].isCompleted.toggle()
                                            saveGoals()
                                        }
                                    }
                                }
                            }
                            .onDelete(perform: deleteActiveGoal) // New delete function
                        }
                        
                        // Completed Goals
                        if !completedGoals.isEmpty {
                            Section(header: Text("Completed").font(.headline).foregroundColor(.primary)) {
                                ForEach(completedGoals) { goal in
                                    if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                                        NavigationLink(value: goal) {
                                            GoalRowView(goal: $goals[index]) {
                                                goals[index].isCompleted.toggle()
                                                saveGoals()
                                            }
                                        }
                                    }
                                }
                                .onDelete(perform: deleteCompletedGoal) // New delete function
                            }
                        }
                    }
                    .listStyle(.plain)
                    .padding(.top, 35)
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
                        .navigationBarTitleDisplayMode(.large) // This is more robust than a custom toolbar

                        // This .onChange modifier is now our single source of truth for saving
                        .onChange(of: goals) {
                            saveGoals()
                            print("A change was detected in the goals array. Data saved.")
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
                AddGoalView(goals: $goals, showingAddGoal: $showingAddGoal) {
                    saveGoals()
                }
            }
            .onAppear(perform: loadGoals)
        }
    }

    // --- Functions ---
    func deleteGoal(id: UUID) {
        goals.removeAll { $0.id == id }
        saveGoals()
    }

    // Helper function for swipe-to-delete on ACTIVE goals
    func deleteActiveGoal(at offsets: IndexSet) {
        // Get goals to be deleted from the filtered 'activeGoals' array
        let goalsToDelete = offsets.map { activeGoals[$0] }
        
        // Get IDs
        let idsToDelete = goalsToDelete.map { $0.id }
        
        // Remove from the main 'goals' array
        goals.removeAll { idsToDelete.contains($0.id) }
        
        saveGoals()
    }
    
    // Helper function for swipe-to-delete on COMPLETED goals
    func deleteCompletedGoal(at offsets: IndexSet) {
        let goalsToDelete = offsets.map { completedGoals[$0] }
        let idsToDelete = goalsToDelete.map { $0.id }
        goals.removeAll { idsToDelete.contains($0.id) }
        saveGoals()
    }
    
    // func deleteGoalAtIndexSet(at offsets: IndexSet) { ... } // This is now replaced

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
