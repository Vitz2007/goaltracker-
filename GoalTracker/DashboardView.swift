//
//  DashboardView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/06.
//

import SwiftUI

struct DashboardView: View {
    // This view now receives the array of goals from ContentView
    let goals: [Goal]
    
    // Computed properties now calculate stats from the passed-in 'goals' array
    private var checkInsThisWeek: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: today) else { return 0 }
        
        return goals.flatMap { $0.checkIns }.filter { $0.date >= weekAgo }.count
    }
    
    private var checkInsThisMonth: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        guard let monthAgo = calendar.date(byAdding: .month, value: -1, to: today) else { return 0 }
        
        return goals.flatMap { $0.checkIns }.filter { $0.date >= monthAgo }.count
    }
    
    private var activeDays: Set<DateComponents> {
        let calendar = Calendar.current
        let allCheckInDates = goals.flatMap { $0.checkIns }.map { $0.date }
        return Set(allCheckInDates.map { calendar.dateComponents([.year, .month, .day], from: $0) })
    }
    
    private var completedGoals: [Goal] {
        goals.filter { $0.isCompleted && !$0.isArchived }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text("dashboard.momentum.title")
                        .font(.title2.bold())
                        .padding(.horizontal)

                    HStack(spacing: 16) {
                        StatBoxView(value: "\(checkInsThisWeek)", label: String(localized: "dashboard.momentum.checkinsThisWeek"), color: .blue)
                        StatBoxView(value: "\(checkInsThisMonth)", label: String(localized: "dashboard.momentum.checkinsThisMonth"), color: .green)
                    }
                    .padding(.horizontal)

                    ActivityHeatmapView(activeDays: activeDays)

                    Text("dashboard.trophyRoom.title")
                        .font(.title2.bold())
                        .padding([.horizontal, .top])
                    
                    if completedGoals.isEmpty {
                        Text("dashboard.trophyRoom.emptyState")
                            .foregroundStyle(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(completedGoals) { goal in
                            Text(goal.title)
                                .font(.headline)
                                .strikethrough()
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(uiColor: .systemGray6), in: RoundedRectangle(cornerRadius: 10))
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("dashboard.title")
        }
    }
}

// This helper view does not need to change
struct StatBoxView: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.largeTitle.bold())
                .foregroundStyle(color)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemGray6), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    // The preview now creates a sample array of goals to display
    DashboardView(goals: [
        Goal(title: "Sample Completed Goal", dueDate: .now, isCompleted: true)
    ])
}
