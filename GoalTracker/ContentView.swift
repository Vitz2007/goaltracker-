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

    // Assume Goal, GoalDetailView, AddGoalView exist and Goal conforms to Identifiable, Codable

    var body: some View {
        NavigationView {
            VStack { // Main content VStack
                // Conditionally display empty state or list
                if goals.isEmpty {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                        .frame(width: 200, height: 50)
                        .overlay(
                            Text("Empty")
                                .foregroundColor(.gray)
                                .font(.title2)
                        )
                        .padding() // Existing padding
                        .padding(.top, 20) // <<-- Pushes the "Empty" view down
                    Spacer()
                } else {
                    List {
                        ForEach(goals) { goal in
                            NavigationLink(destination: GoalDetailView(goal: goal)) {
                                HStack(alignment: .center) {
                                    Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundColor(goal.isCompleted ? .green : .gray)
                                        .onTapGesture {
                                            if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                                                goals[index].isCompleted.toggle()
                                                saveGoals()
                                            }
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
                            }
                        }
                        .onDelete(perform: deleteGoal)
                    }
                    .listStyle(.plain)
                    .padding(.top, 60) // <<-- Pushes the List view down
                }

                // Spacer to push button towards bottom if needed, especially when list is empty
                // If the list exists, Spacer might not be necessary depending on List behavior
                 if !goals.isEmpty {
                     Spacer() // Add Spacer only when the list is populated if needed
                 }


                // Plus Button
                Button {
                    showingAddGoal = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding(.bottom) // Padding for the button from the bottom edge

            } // End of VStack
            .navigationTitle("My Goals") // Sets semantic title
            .navigationBarTitleDisplayMode(.inline) // Use inline mode
            .toolbar { // Customize the visual title
                ToolbarItem(placement: .principal) {
                    Text("My Goals")
                        .font(.system(size: 45)) // Your chosen font size
                        .padding(.top, 50) // <<-- Pushes title text down within the bar
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                // Pass necessary bindings and the save action
                AddGoalView(goals: $goals, showingAddGoal: $showingAddGoal) {
                    saveGoals()
                }
            }
            .onAppear(perform: loadGoals) // Load goals when the view appears
        } // End of NavigationView
         // Optional: If needed for iPad layout consistency
        // .navigationViewStyle(.stack)
    } // End of body

    // --- Functions (deleteGoal, saveGoals, loadGoals) ---
    func deleteGoal(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
        saveGoals()
    }

    // MARK: - Data Persistence (UserDefaults)
    func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: "savedGoals")
        }
    }

    func loadGoals() {
        if let savedGoals = UserDefaults.standard.data(forKey: "savedGoals") {
            if let decodedGoals = try? JSONDecoder().decode([Goal].self, from: savedGoals) {
                goals = decodedGoals
                return
            }
        }
        goals = []
    }
}

// ----- Preview -----
// Make sure you have your actual Goal struct defined elsewhere
// and GoalDetailView/AddGoalView defined
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // You might need to provide dummy data or views here if needed for preview
        ContentView()
    }
}

// ----- Dummy Supporting Structures (Remove if you have real ones) -----
// Ensure these are removed if you have them defined elsewhere to avoid ambiguity
/*
struct Goal: Identifiable, Codable { ... }
struct GoalDetailView: View { ... }
struct AddGoalView: View { ... }
*/
