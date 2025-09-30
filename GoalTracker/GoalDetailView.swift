//
//  GoalDetailView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/17.
//

import SwiftUI

// Moved to the top level to prevent any scope errors.
enum GoalAction: CaseIterable, Equatable {
    case edit, finish, delete
}

struct GoalDetailView: View {
    @Binding var goal: Goal
    var onDelete: (UUID) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appSettings: AppSettings

    // State for sheets, alerts, and pop-ups
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingAddCheckInNoteSheet = false
    @State private var showingUndoConfirmation = false

    // MARK: - Computed Properties
    private var category: GoalCategory? {
        GoalLibrary.categories.first { $0.id == goal.categoryID }
    }
    
    private var categoryColor: Color {
        appSettings.themeColor(for: category?.colorName ?? "")
    }
    
    private var iconNameToDisplay: String {
        if let iconName = goal.iconName, !iconName.isEmpty { return iconName }
        if let iconName = category?.iconName, !iconName.isEmpty { return iconName }
        return "target"
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    goalInfoCard.padding(.horizontal)
                    if appSettings.streaksEnabled {
                        streaksAndChartSection.padding(.horizontal)
                    }
                    checkInButton.padding(.horizontal)
                    Color.clear.frame(height: 100)
                }
                .padding(.top)
            }
            .ignoresSafeArea(.container, edges: .bottom)
            
            undoPopup
        }
        .navigationTitle("goalDetail.title")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            ActionSliderView(
                onAction: { action in handle(action) },
                isCompleted: goal.isCompleted
            )
        }
        .sheet(isPresented: $showingEditSheet) { EditGoalView(goal: $goal) }
        .sheet(isPresented: $showingAddCheckInNoteSheet) {
            AddCheckInNoteView { noteText in
                let newCheckIn = CheckInRecord(date: Date(), note: noteText)
                goal.checkIns.append(newCheckIn)
                updateProgress()
                withAnimation { showingUndoConfirmation = true }
            }
        }
        .alert("goalDetail.alert.delete.title", isPresented: $showingDeleteAlert) {
            Button(role: .destructive, action: { onDelete(goal.id) }) {
                Text("common.delete")
            }
            Button("common.cancel", role: .cancel) { }
        } message: {
            Text("goalDetail.alert.delete.message")
        }
    }
    
    // MARK: - UI Components
    
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
            
            Text(goal.title.contains("category.") ? LocalizedStringKey(goal.title) : LocalizedStringKey(goal.title))
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
            
            GoalProgressView(goal: goal)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var streaksAndChartSection: some View {
        VStack(alignment: .leading) {
            Text("detailView.activity.title")
                .font(.headline)
            
            ActivityBarChartView(activityData: goal.recentActivity)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
    
    private var checkInButton: some View {
        Button {
            if !goal.isCompleted { showingAddCheckInNoteSheet = true }
        } label: {
            Label("goalDetail.button.checkInToday", systemImage: "checkmark")
                .font(.headline.bold())
                .padding()
                .frame(maxWidth: .infinity)
                .background(goal.isCompleted ? Color.gray.gradient : appSettings.currentAccentColor.gradient)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(goal.isCompleted)
    }
    
    @ViewBuilder
    private var undoPopup: some View {
        if showingUndoConfirmation {
            VStack {
                Spacer()
                HStack {
                    Text("goalDetail.popup.checkedIn")
                    Spacer()
                    Button("common.undo") {
                        _ = goal.checkIns.popLast()
                        updateProgress()
                        withAnimation { showingUndoConfirmation = false }
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
                        if showingUndoConfirmation { withAnimation { showingUndoConfirmation = false } }
                    }
                }
            }
            .padding(.bottom, 80)
        }
    }
    
    // MARK: - Functions
    
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

// MARK: - Action Slider and Dependencies

struct ActionSliderView: View {
    var onAction: (GoalAction) -> Void
    var isCompleted: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selection: GoalAction = .finish
    @State private var isDragging = false
    
    var body: some View {
        GeometryReader { geometry in
            let segmentWidth = geometry.size.width / CGFloat(GoalAction.allCases.count)
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.15), radius: 5, y: 3)

                Capsule()
                    .fill(
                        colorScheme == .light
                        // Light mode pill appearance control
                        ? AnyShapeStyle(RadialGradient(gradient: Gradient(colors: [Color.white, Color(.systemGray5)]), center: .topLeading, startRadius: 1, endRadius: 80))
                        // Dark mode pill appearance control
                        : AnyShapeStyle(RadialGradient(gradient: Gradient(colors: [Color(.systemGray2), Color(.systemGray6)]), center: .topLeading, startRadius: 1, endRadius: 90))
                    )
                    .overlay(
                        colorScheme == .light
                        ? AnyView(Capsule().stroke(Color(.systemGray4), lineWidth: 0.5))
                        : AnyView(Capsule().stroke(Color(.systemGray3), lineWidth: 1))
                    )
                    .shadow(
                        color: colorScheme == .light ? .black.opacity(0.1) : .black.opacity(0.4),
                        radius: colorScheme == .light ? 3 : 5,
                        x: 0,
                        y: colorScheme == .light ? 3 : 7
                    )
                    .frame(width: segmentWidth)
                    .offset(x: offset(for: selection, in: geometry.size))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selection)

                HStack(spacing: 0) {
                    ForEach(GoalAction.allCases, id: \.self) { action in
                        actionIcon(for: action)
                            .frame(width: segmentWidth)
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { value in
                        guard !isCompleted else { return }
                        isDragging = true
                        self.selection = action(for: value.location.x, in: geometry.size)
                    }
                    .onEnded { value in
                        isDragging = false
                        let finalAction = action(for: value.location.x, in: geometry.size)
                        handleSelection(action: finalAction)
                    }
            )
        }
        .frame(height: 80)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func actionIcon(for action: GoalAction) -> some View {
        VStack {
            Image(systemName: iconName(for: action))
            Text(title(for: action))
                .font(.caption)
        }
        .foregroundStyle(selection == action && !isDragging ? color(for: action) : .secondary)
        .opacity(isCompleted && (action == .edit || action == .delete) ? 0.4 : 1.0)
        .onTapGesture { handleSelection(action: action) }
    }
    
    private func handleSelection(action: GoalAction) {
        if isCompleted && (action == .edit || action == .delete) { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        self.selection = action
        onAction(action)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring()) { self.selection = .finish }
        }
    }
    
    private func offset(for selection: GoalAction, in size: CGSize) -> CGFloat {
        let segmentWidth = size.width / CGFloat(GoalAction.allCases.count)
        switch selection {
        case .edit:   return 0
        case .finish: return segmentWidth
        case .delete: return segmentWidth * 2
        }
    }
    
    private func action(for xPosition: CGFloat, in size: CGSize) -> GoalAction {
        let segmentWidth = size.width / CGFloat(GoalAction.allCases.count)
        let index = max(0, min(2, Int(xPosition / segmentWidth)))
        return GoalAction.allCases[index]
    }
    
    private func color(for action: GoalAction) -> Color {
        switch action { case .edit: return .blue; case .finish: return .green; case .delete: return .red }
    }
    
    private func iconName(for action: GoalAction) -> String {
        if action == .finish && isCompleted { return "arrow.uturn.backward" }
        switch action { case .edit: return "pencil"; case .finish: return "flag.checkered"; case .delete: return "trash" }
    }
    
    private func title(for action: GoalAction) -> LocalizedStringKey {
        if action == .finish && isCompleted { return "goalDetail.button.reopen" }
        switch action { case .edit: return "common.edit"; case .finish: return "goalDetail.button.finish"; case .delete: return "common.delete" }
    }
}

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        @State private var sampleGoal = Goal(title: "Preview Goal")
        
        var body: some View {
            NavigationView {
                GoalDetailView(
                    goal: $sampleGoal,
                    onDelete: { _ in print("Delete triggered in preview") }
                )
                .environmentObject(AppSettings.shared)
            }
        }
    }
    
    return PreviewWrapper()
}
