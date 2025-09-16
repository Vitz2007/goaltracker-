//
//  MainTabView.swift
//  GoalTracker
//
//  Created by AJ on 2025/08/31.
//

import SwiftUI
import WidgetKit

struct MainTabView: View {
    @Binding var goals: [Goal]
    @Binding var path: NavigationPath
    @Binding var selectedTab: Int
    
    @Binding var showingAddGoal: Bool
    @Binding var showingSettings: Bool
    
    @Binding var currentFilter: GoalFilter
    @Binding var currentSortOrder: SortOrder
    
    @Binding var confettiStartPoint: CGPoint?
    
    @EnvironmentObject var appSettings: AppSettings

    private var filteredAndSortedGoals: [Goal] {
        let filtered: [Goal]
        switch currentFilter {
        case .all:
            filtered = goals.filter { !$0.isArchived }
        case .active:
            filtered = goals.filter { !$0.isCompleted && !$0.isArchived }
        }
        
        switch currentSortOrder {
        case .byTitle:
            return filtered.sorted { $0.title.lowercased() < $1.title.lowercased() }
        case .byDueDate:
            return filtered.sorted { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) }
        case .byCreationDate:
            return filtered.sorted { ($0.startDate ?? .distantPast) > ($1.startDate ?? .distantPast) }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            goalsList
                .tabItem { Label("contentView.title", systemImage: "list.bullet.circle.fill") }
                .tag(0)
            
            DashboardView(goals: goals)
                .tabItem { Label("contentView.tab.dashboard", systemImage: "chart.pie.fill") }
                .tag(1)
        }
        .navigationTitle(selectedTab == 0 ? LocalizedStringKey("contentView.title") : "")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if selectedTab == 0 {
                goalsToolbar
            }
        }
    }
    
    private var goalsToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Menu {
                Menu("contentView.menu.sortBy") {
                    Button { currentSortOrder = .byTitle } label: { Label(LocalizedStringKey("sort.byTitle"), systemImage: currentSortOrder == .byTitle ? "checkmark" : "") }
                    Button { currentSortOrder = .byDueDate } label: { Label(LocalizedStringKey("sort.byDueDate"), systemImage: currentSortOrder == .byDueDate ? "checkmark" : "") }
                    Button { currentSortOrder = .byCreationDate } label: { Label(LocalizedStringKey("sort.byCreationDate"), systemImage: currentSortOrder == .byCreationDate ? "checkmark" : "") }
                }
                Menu("contentView.menu.filter") {
                    Button { currentFilter = .all } label: { Label(LocalizedStringKey("filter.all"), systemImage: currentFilter == .all ? "checkmark" : "") }
                    Button { currentFilter = .active } label: { Label(LocalizedStringKey("filter.active"), systemImage: currentFilter == .active ? "checkmark" : "") }
                }
                Divider()
                Button { showingSettings = true } label: { Label("common.settings", systemImage: "gearshape") }
            } label: { Image(systemName: "line.3.horizontal.decrease.circle") }
        }
    }
    
    private var goalsList: some View {
        VStack {
            if filteredAndSortedGoals.isEmpty {
                EmptyStateView()
            } else {
                List {
                    ForEach(filteredAndSortedGoals) { goal in
                        NavigationLink(value: goal) {
                            GoalRowView(goal: goal, settings: appSettings) { position in
                                // Find the index of the goal to modify it
                                if let index = self.goals.firstIndex(where: { $0.id == goal.id }) {
                                    if !self.goals[index].isCompleted {
                                        self.confettiStartPoint = position
                                        CelebrationManager.shared.start(goal: self.goals[index])
                                    }
                                    self.goals[index].isCompleted.toggle()
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: deleteGoal)
                }
                .listStyle(.plain)
            }
            
            AddGoalButtonView { showingAddGoal = true }
                .padding(.bottom)
        }
        .overlay { ConfettiView(isCelebrating: .constant(CelebrationManager.shared.isCelebrating), startPoint: confettiStartPoint) }
    }

    private func deleteGoal(at offsets: IndexSet) {
        let goalsToDelete = offsets.map { filteredAndSortedGoals[$0] }
        let idsToDelete = Set(goalsToDelete.map { $0.id })
        goals.removeAll { idsToDelete.contains($0.id) }
    }
}
