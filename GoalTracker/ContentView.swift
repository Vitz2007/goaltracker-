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

    var body: some View {
        NavigationView {
            VStack { // Main content of VStack
                // Conditionally display empty state or list
                if goals.isEmpty {
                    EmptyStateView()
                        .frame(maxHeight: .infinity) // Allows EmptyStateView's Spacers to function
                } else {
                    List {
                        ForEach($goals) { $goal in // Use $goals to pass bindings to GoalRowView if needed
                            NavigationLink(destination: GoalDetailView(
                                goal: goal, // Pass the non-binding goal below
                                onUpdate: updateGoal,
                                onDelete: deleteGoal
                            )) {
                                GoalRowView(goal: $goal) { // Pass binding for direct modification
                                    // This functions as  onToggleCompletion action
                                    goal.isCompleted.toggle()
                                    updateGoal(goal) // Persist the change
                                }
                            }
                        }
                        .onDelete(perform: deleteGoalAtIndexSet) // Swipe-to-delete
                    }
                    .listStyle(.plain)
                    .padding(.top, 35) // padding added because squashed
                }

                // Spacer to push button towards bottom, only if list is not empty
                // If list is empty, EmptyStateView handles its own spacing.
                if !goals.isEmpty {
                    Spacer()
                }

                // Plus Button, always visible or conditionally? Keep in mind...
                // For now, keeping it as it was, consider placement if goals are empty.
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
    func updateGoal(_ updatedGoal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == updatedGoal.id }) {
            goals[index] = updatedGoal
            saveGoals()
        }
    }

    func deleteGoal(id: UUID) {
        goals.removeAll { $0.id == id }
        saveGoals()
    }

    func deleteGoalAtIndexSet(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
        saveGoals()
    }

    func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: "savedGoals")
            print("Goals saved successfully.")
        } else {
            print("Error: Failed to encode goals for saving.")
        }
    }

    func loadGoals() {
        if let savedGoalsData = UserDefaults.standard.data(forKey: "savedGoals") {
            if let decodedGoals = try? JSONDecoder().decode([Goal].self, from: savedGoalsData) {
                goals = decodedGoals
                print("Goals loaded successfully: \(goals.count) goals.")
                return
            } else {
                print("Error: Failed to decode saved goals.")
            }
        } else {
            print("No saved goals found in UserDefaults.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
