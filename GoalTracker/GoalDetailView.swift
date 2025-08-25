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

    private var category: GoalCategory? {
        GoalLibrary.categories.first { $0.id == goal.categoryID }
    }
    
    private var categoryColor: Color {
        switch category?.colorName {
        case "green": return .green
        case "red": return .red
        case "blue": return .blue
        default: return .accentColor
        }
    }

    var body: some View {
        List {
            goalInfoCard
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            
            checkInButton
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            
            activityChart
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .overlay(alignment: .bottom) { actionToolbar }
        .overlay(alignment: .bottom) { undoPopup }
        .animation(.easeInOut, value: showingUndoConfirmation)
        .navigationTitle("goalDetail.title")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditSheet) { EditGoalView(goal: $goal) } // Pass as binding
        .alert("goalDetail.alert.delete.title", isPresented: $showingDeleteAlert) {
            Button("common.delete", role: .destructive) { onDelete(goal.id) }
            Button("common.cancel", role: .cancel) {}
        } message: {
            Text("goalDetail.alert.delete.message")
        }
    }

    // --- View Components ---

    private var goalInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: goal.iconName ?? category?.iconName ?? "target")
                    .font(.title)
                    .foregroundStyle(categoryColor)
                
                Text(LocalizedStringKey(category?.name ?? "category.general"))
                    .font(.headline)
                    .foregroundStyle(categoryColor)
                
                Spacer()
            }
            
            Text(goal.title)
                .font(.largeTitle.bold())
                .strikethrough(goal.isCompleted, color: .primary)
                .opacity(goal.isCompleted ? 0.6 : 1.0)
            
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
                goal.checkIns.append(CheckInRecord()) // Use checkIns and add a CheckInRecord
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
    
    private var activityChart: some View {
        VStack(alignment: .leading) {
            Text("goalDetail.chart.title")
                .font(.headline)
            
            // This assumes your Goal struct has a recentActivity computed property
            // that is compatible with the Codable model.
            // ActivityBarChartView(activityData: goal.recentActivity)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var actionToolbar: some View {
        HStack {
            Button { self.showingEditSheet = true } label: {
                Label("common.edit", systemImage: "pencil")
            }
            .disabled(goal.isCompleted)
            
            Spacer()
            
            Button {
                goal.isCompleted.toggle()
                updateProgress()
            } label: {
                Label(goal.isCompleted ? LocalizedStringKey("goalDetail.button.reopen") : LocalizedStringKey("goalDetail.button.finish"), systemImage: goal.isCompleted ? "arrow.counterclockwise" : "flag.checkered.2.crossed")
            }
            
            Spacer()
            
            if goal.isCompleted {
                Button {
                    goal.isArchived = true
                    dismiss()
                } label: {
                    Label("archive.title", systemImage: "archivebox.fill")
                }
            } else {
                Button(role: .destructive) {
                    self.showingDeleteAlert = true
                } label: {
                    Label("common.delete", systemImage: "trash")
                }
            }
        }
        .padding()
        .background(.bar)
    }
    
    private var undoPopup: some View {
        Group {
            if showingUndoConfirmation {
                HStack {
                    Text("goalDetail.popup.checkedIn")
                    Spacer()
                    Button("common.undo") {
                        _ = goal.checkIns.popLast() // Use checkIns
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
