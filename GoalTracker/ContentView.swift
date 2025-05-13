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
            VStack { // Main content VStack

                // Conditionally display empty state or list
                if goals.isEmpty {
                    // --- Your Empty State View ---
                    RoundedRectangle(cornerRadius: 10)
                       .fill(Color(.systemGray6))
                       .frame(width: 250, height: 55)
                       .overlay(
                           Text("Empty")
                               .foregroundColor(.gray)
                               .font(.title2)
                       )
                       .padding()
                       .padding(.top, 55)
                    Spacer()
                    // --- End Empty State ---
                } else {
                    List {
                        ForEach(goals) { goal in
                            NavigationLink(destination: GoalDetailView(
                                goal: goal,
                                onUpdate: updateGoal, // Pass update function
                                onDelete: deleteGoal  // Pass delete function (using ID)
                            )) {
                                // --- Goal Row HStack ---
                                HStack(alignment: .center) {
                                    Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundColor(goal.isCompleted ? .green : .gray)
                                        .onTapGesture {
                                            var updatedGoal = goal
                                            updatedGoal.isCompleted.toggle()
                                            updateGoal(updatedGoal) // Allow toggling from list view too
                                        }
                                        .frame(width: 48)

                                    VStack(alignment: .leading) {
                                        Text(goal.title)
                                            .font(.headline)
                                        if let dueDate = goal.dueDate {
                                            Text("Due: \(dueDate, style: .date)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 15)
                                // --- End Goal Row HStack ---
                            }
                        }
                        .onDelete(perform: deleteGoalAtIndexSet) // Swipe-to-delete
                    }
                    .listStyle(.plain)
                    .padding(.top, 20) // Add padding above list
                }

                // Spacer to push button towards bottom
                //
                if !goals.isEmpty {
                    Spacer()
                }

                // --- Plus Button ---
                Button { // Action for Plus Button
                    showingAddGoal = true
                } label: {
                    // --- Label Code START ---
                    Image(systemName: "plus")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 3) // Optional shadow
                    // --- Label Code END ---
                }
                .padding(.bottom) // Padding for the button

            } // End of main VStack
            .navigationTitle("My Goals") // Keep for accessibility & standard behavior fallback
            .navigationBarTitleDisplayMode(.inline) // Use inline mode

            // --- Toolbar START ---
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Goals")
                        .font(.system(size: 43)) // Example: Custom size
                        .padding(.top, 44)       // Example: Add padding if needed
                }
            }
            // --- Toolbar END ---

            // --- Sheet START ---
            .sheet(isPresented: $showingAddGoal) {
                 // Make sure AddGoalView initializer matches this call
                 // AddGoalView takes these bindings/closures
                AddGoalView(goals: $goals, showingAddGoal: $showingAddGoal) {
                     // This closure is the 'onSave' action for AddGoalView
                     saveGoals()
                 }
            }
            // --- Sheet END ---

            .onAppear(perform: loadGoals) // Load goals when the view appears
        } // End of NavigationView
         // Optional: For iPad layout consistency
        // .navigationViewStyle(.stack)
    } // End body


    // --- Use of Functions ---

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

    // MARK: - Data Persistence (UserDefaults)
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
    // --- End the Created Functions ---

}

// --- Preview ---
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
