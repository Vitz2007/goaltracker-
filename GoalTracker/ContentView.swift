//
//  ContentView.swift
//  GoalTrackerv2
//
//  Created by AJ on 2025/04/14.
//

import SwiftUI
import UserNotifications
import WidgetKit

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
    @State private var confettiStartPoint: CGPoint? = nil

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
                requestNotificationPermission()
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
    
    private var mainAppView: some View {
        NavigationStack(path: $path) {
            MainTabView(
                goals: $goals,
                path: $path,
                selectedTab: $selectedTab,
                showingAddGoal: $showingAddGoal,
                showingSettings: $showingSettings,
                currentFilter: $currentFilter,
                currentSortOrder: $currentSortOrder,
                confettiStartPoint: $confettiStartPoint
            )
            .navigationDestination(for: Goal.self) { goal in
                if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                    GoalDetailView(goal: $goals[index], onDelete: deleteGoal)
                }
            }
            .sheet(isPresented: $showingSettings) { SettingsView() }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(goals: $goals, showingAddGoal: $showingAddGoal, onGoalAdded: saveGoals)
            }
        }
        .onAppear(perform: loadGoals)
        .onChange(of: goals) { _, _ in saveGoals() }
    }

    func deleteGoal(id: UUID) {
        goals.removeAll { $0.id == id }
        saveGoals()
    }

    func saveGoals() {
        DataManager.shared.save(goals: self.goals)
        WidgetCenter.shared.reloadAllTimelines()
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
