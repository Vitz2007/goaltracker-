//
//  GoalDetailView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/17.
//

import SwiftUI

struct GoalDetailView: View {
    @Binding var goal: Goal
    var onDelete: (UUID) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingUndoConfirmation = false
    
    @EnvironmentObject var appSettings: AppSettings

    private var category: GoalCategory? {
        GoalLibrary.categories.first { $0.id == goal.categoryID }
    }
    
    private var categoryColor: Color {
        appSettings.themeColor(for: category?.colorName ?? "")
    }
    
    private var iconNameToDisplay: String {
        if let iconName = goal.iconName, !iconName.isEmpty {
            return iconName
        }
        if let iconName = category?.iconName, !iconName.isEmpty {
            return iconName
        }
        return "target"
    }

    var body: some View {
        List {
            goalInfoCard
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            
            checkInButton
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .overlay(alignment: .bottom) {
            ActionSliderView(onAction: handle, isCompleted: goal.isCompleted)
                .padding(.bottom)
        }
        .overlay(alignment: .bottom) { undoPopup }
        .animation(.easeInOut, value: showingUndoConfirmation)
        .navigationTitle("goalDetail.title")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditSheet) { EditGoalView(goal: $goal) }
        .alert("goalDetail.alert.delete.title", isPresented: $showingDeleteAlert) {
            Button("common.delete", role: .destructive) { onDelete(goal.id) }
            Button("common.cancel", role: .cancel) {}
        } message: {
            Text("goalDetail.alert.delete.message")
        }
    }
    
    private func handle(_ action: GoalAction) {
        switch action {
        case .edit:
            showingEditSheet = true
        case .finish:
            goal.isCompleted.toggle()
            updateProgress()
        case .delete:
            showingDeleteAlert = true
        }
    }

    private var goalInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: iconNameToDisplay)
                    .font(.title)
                    .foregroundStyle(categoryColor)
                
                Text(LocalizedStringKey(category?.name ?? "category.general"))
                    .font(.headline)
                    .foregroundStyle(categoryColor)
                
                Spacer()
            }
            
            if goal.title.contains("category.") {
                Text(LocalizedStringKey(goal.title))
                    .font(.largeTitle.bold())
                    .strikethrough(goal.isCompleted, color: .primary)
                    .opacity(goal.isCompleted ? 0.6 : 1.0)
            } else {
                Text(goal.title)
                    .font(.largeTitle.bold())
                    .strikethrough(goal.isCompleted, color: .primary)
                    .opacity(goal.isCompleted ? 0.6 : 1.0)
            }
            
            HStack {
                if let startDate = goal.startDate {
                    Label(startDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar.badge.plus")
                }
                Spacer()
                if let dueDate = goal.dueDate {
                    Label(dueDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar.badge.exclamationmark")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var checkInButton: some View {
        Button(action: {
            if !goal.isCompleted {
                goal.checkIns.append(CheckInRecord())
                self.showingUndoConfirmation = true
                updateProgress()
            }
        }) {
            Label("goalDetail.button.checkInToday", systemImage: "checkmark")
                .font(.headline.bold())
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor.gradient)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(goal.isCompleted)
    }
    
    private var undoPopup: some View {
        Group {
            if showingUndoConfirmation {
                HStack {
                    Text("goalDetail.popup.checkedIn")
                    Spacer()
                    Button("common.undo") {
                        _ = goal.checkIns.popLast()
                        updateProgress()
                    }
                }
                .padding()
                .background(.regularMaterial)
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding()
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation { showingUndoConfirmation = false }
                    }
                }
            }
        }
    }
    
    private func updateProgress() {
        if goal.isCompleted {
            goal.completionPercentage = 1.0
        } else {
            if goal.targetCheckIns > 0 {
                let calculatedPercentage = Double(goal.checkIns.count) / Double(goal.targetCheckIns)
                goal.completionPercentage = min(1.0, max(0.0, calculatedPercentage))
            } else {
                goal.completionPercentage = 0
            }
        }
    }
}
