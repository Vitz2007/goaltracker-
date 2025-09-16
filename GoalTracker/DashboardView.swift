//
//  DashboardView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/06.
//

import SwiftUI

struct DashboardView: View {
    let goals: [Goal]
    
    private var viewModel: DashboardViewModel {
        DashboardViewModel(goals: goals)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // This title scrolls with the content
                Text("dashboard.title")
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                
                Text("dashboard.momentum.title")
                    .font(.title2.bold())
                    .padding(.horizontal)

                HStack(spacing: 16) {
                    StatBoxView(value: "\(viewModel.checkInsThisWeek)", label: String(localized: "dashboard.momentum.checkinsThisWeek"), color: .blue)
                    StatBoxView(value: "\(viewModel.checkInsThisMonth)", label: String(localized: "dashboard.momentum.checkinsThisMonth"), color: .green)
                }
                .padding(.horizontal)

                ActivityHeatmapView(activeDays: viewModel.activeDays)

                Text("dashboard.trophyRoom.title")
                    .font(.title2.bold())
                    .padding([.horizontal, .top])
                
                if viewModel.completedGoals.isEmpty {
                    Text("dashboard.trophyRoom.emptyState")
                        .foregroundStyle(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                } else {
                    ForEach(viewModel.completedGoals) { goal in
                        if goal.title.contains("category.") {
                            Text(LocalizedStringKey(goal.title))
                                .font(.headline)
                                .strikethrough()
                        } else {
                            Text(goal.title)
                                .font(.headline)
                                .strikethrough()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(uiColor: .systemGray6), in: RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
    }
}

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
    DashboardView(goals: [
        Goal(title: "Sample Completed Goal", dueDate: .now, isCompleted: true)
    ])
}
