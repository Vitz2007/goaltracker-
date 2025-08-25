//
//  ArchivedGoalsView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/09.
//

import SwiftUI

struct ArchivedGoalsView: View {
    @State private var allGoals: [Goal] = []
    
    // A computed property to get just the archived goals
    private var archivedGoals: [Goal] {
        allGoals.filter { $0.isArchived }
    }
    
    private func save(goals: [Goal]) {
        DataManager.shared.save(goals: goals)
    }

    var body: some View {
        NavigationStack {
            if archivedGoals.isEmpty {
                // Show a message if the archive is empty
                VStack {
                    Image(systemName: "archivebox")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("archive.emptyState.message")
                        .font(.headline)
                        .padding(.top, 4)
                }
                .navigationTitle("archive.title")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                // If there are archived goals, display them in a list
                List(archivedGoals) { goal in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(goal.title)
                                .strikethrough()
                            
                            if let dueDate = goal.dueDate {
                                let formattedDate = dueDate.formatted(date: .abbreviated, time: .omitted)
                                let completedText = String(format: NSLocalizedString("archive.completedOnDate", comment: ""), formattedDate)
                                Text(completedText)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            unarchive(goal: goal)
                        } label: {
                            Label("archive.button.unarchive", systemImage: "arrow.uturn.backward.circle.fill")
                        }
                        .tint(.secondary)
                        .buttonStyle(.borderless)
                    }
                }
                .navigationTitle("archive.title")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear(perform: loadAllGoals)
    }
    
    private func loadAllGoals() {
        self.allGoals = DataManager.shared.load()
    }
    
    private func unarchive(goal: Goal) {
        if let index = allGoals.firstIndex(where: { $0.id == goal.id }) {
            allGoals[index].isArchived = false
            save(goals: allGoals)
        }
    }
}


#Preview {
    // The preview will now show the empty state, as it has no sample data.
    // This allows the code to compile correctly.
    ArchivedGoalsView()
}
