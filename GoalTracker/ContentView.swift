//
//  ContentView.swift
//  GoalTrackerv2
//
//  Created by AJ on 2025/04/14.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var goals: [Goal] = []
    @State private var showingAddGoal = false
    @State private var showingSettings = false
    @State private var path = NavigationPath()

    @State private var currentSortOrder: SortOrder = .byCreationDate
    @State private var currentFilter: GoalFilter = .active
    
    @EnvironmentObject var appSettings: AppSettings
    @State private var onboardingManager = OnboardingManager()
    @State private var selectedTab: Int = 0

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
        if onboardingManager.hasCompletedOnboarding {
            mainAppView
        } else {
            OnboardingView(manager: onboardingManager) { goalTitle in
                if !goalTitle.trimmingCharacters(in: .whitespaces).isEmpty {
                    let newGoal = Goal(
                        title: goalTitle,
                        dueDate: Calendar.current.date(byAdding: .month, value: 1, to: .now)!
                    )
                    goals.append(newGoal)
                    saveGoals()
                }
                onboardingManager.completeOnboarding()
            }
        }
    }
    
    // ✅ This view is now simpler.
    private var mainAppView: some View {
        NavigationStack(path: $path) {
            tabViewContent
        }
    }
    
    // ✅ The complex TabView and its modifiers have been extracted here.
    private var tabViewContent: some View {
        TabView(selection: $selectedTab) {
            goalsList
                .tabItem { Label("contentView.title", systemImage: "list.bullet.circle.fill") }
                .tag(0)
            
            DashboardView(goals: goals)
                .tabItem { Label("contentView.tab.dashboard", systemImage: "chart.pie.fill") }
                .tag(1)
        }
        .navigationTitle(selectedTab == 0 ? LocalizedStringKey("contentView.title") : LocalizedStringKey("dashboard.title"))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if selectedTab == 0 {
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
        }
        .navigationDestination(for: Goal.self) { goal in
            if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                GoalDetailView(goal: $goals[index], onDelete: deleteGoal)
            }
        }
        .sheet(isPresented: $showingSettings) { SettingsView() }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView(goals: $goals, showingAddGoal: $showingAddGoal, onGoalAdded: saveGoals)
        }
        .onAppear(perform: loadGoals)
        .onChange(of: goals) { _, _ in saveGoals() }
    }
    
    private var goalsList: some View {
        VStack {
            if filteredAndSortedGoals.isEmpty {
                EmptyStateView()
            } else {
                List {
                    ForEach(filteredAndSortedGoals) { goal in
                        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                            NavigationLink(value: goal) {
                                GoalRowView(goal: $goals[index], settings: appSettings) {
                                    if !goals[index].isCompleted {
                                        // CelebrationManager.shared.start(goal: goals[index])
                                    }
                                    goals[index].isCompleted.toggle()
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .onDelete(perform: deleteGoal)
                }
                .listStyle(.plain)
            }
            
            AddGoalButtonView { showingAddGoal = true }
                .padding(.bottom)
        }
    }

    func deleteGoal(at offsets: IndexSet) {
        let goalsToDelete = offsets.map { filteredAndSortedGoals[$0] }
        let idsToDelete = Set(goalsToDelete.map { $0.id })
        goals.removeAll { idsToDelete.contains($0.id) }
    }
    
    func deleteGoal(id: UUID) {
        goals.removeAll { $0.id == id }
    }

    func saveGoals() {
        DataManager.shared.save(goals: self.goals)
    }

    func loadGoals() {
        self.goals = DataManager.shared.load()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted { print("Notification permission granted.") }
            else if let error = error { print(error.localizedDescription) }
        }
    }
}
