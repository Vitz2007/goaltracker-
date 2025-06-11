//
//  ContentView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/07.
//
import SwiftUI

struct ContentView: View {
    @State private var goals: [Goal] = []
    @State private var showingAddGoal = false // For AddGoalView sheet
    
    // NavigationPath is used by NavigationStack to track navigation state
    @State private var path = NavigationPath()
    
    // Computed properties to automatically filter goals
    private var activeGoals: [Goal] {
        goals.filter { !0.isCompleted }
    }
    
    // For read-only array of completed goals
    private var completedGoals: [Goals] {
        goals.filter { $0.isCompleted }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack { // Main content of VStack
                // Conditionally display empty state or list
                if goals.isEmpty {
                    EmptyStateView()
                        .frame(maxHeight: .infinity) // Allows EmptyStateView's Spacers to function
                } else {
                    List {
                        Section(header: Text("Active").font(.headline).foregroundColor(.primary)) {
                            ForEach(activeGoals) { goal in
                                // We need to find the binding to the original goal
                                if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                                    NavigationLink(value: goal) {
                                        GoalRowView(goal: $goals[index]) {
                                            goals[index].isCompleted.toggle()
                                            saveGoals()
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
                    // Adding Haptic Feedback to '+' here
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.prepare()
                    generator.impactOccurred()
                    // End Haptic Feedback Code
                    showingAddGoal = true
                }
                // For plus button at the very bottom,

            } // End of main VStack
            .navigationTitle("My Goals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // Custom Toolbar
                ToolbarItem(placement: .principal) {
                    Text("My Goals")
                        .font(.system(size: 41)) // Adjusted size for typical toolbar
                        .padding(.top, 35)       // Adjusted padding
                }
            }
            
            // Modifier added to tell NavigationStack what view to buildwhen it sees some value of type Goal
            .navigationDestination(for: Goal.self) { goal in
                // Find binding to the goal in array to pass it
                if let index = goals.firstIndex(where: { $0.id == goal.id}) {
                    GoalDetailView(
                        goal: $goals[index], // passing the live binding
                        onDelete: { id in
                            deleteGoal(id: id)
                            // Tells navigation to go back one step after a delete
                            if !path.isEmpty {
                                path.removeLast()
                            }
                        }
                    )
                }}
            
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(goals: $goals, showingAddGoal: $showingAddGoal) {
                    saveGoals()
                }
            }
            .onAppear(perform: loadGoals)
        }
        // .navigationViewStyle(.stack) // Consider for iPad if needed
    }

    // --- Functions ---
    func deleteGoal(id: UUID) {
        goals.removeAll { $0.id == id }
        saveGoals()
    }
    
    // Helper function for swipe-to-delete on Active goals added
    func deleteActiveGoal(at offsets: IndexSet) {
        // Prioritize goals to be deleted from filtered 'activeGoals'
        let goalsToDelete = offsets.map { activeGoals[$0] }
        //  Get IDs
        let idsToDelete = goalsToDelete.map { $0.id }
        // Remove from the main 'goals' array
        goals.removeALL { idsToDelete.contain($0.id) }
        saveGoals()
    }
    
    // Helper function to swipe-to-delete on 'Completed' goals
    func deleteCompletedGoals(at offsets: IndexSet) {
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
