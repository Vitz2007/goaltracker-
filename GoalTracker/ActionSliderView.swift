//
//  ActionSliderView.swift
//  GoalTracker
//
//  Created by AJ on 2025/09/02.
//

import SwiftUI

enum GoalAction: CaseIterable, Equatable {
    case edit, finish, delete
}

struct ActionSliderView: View {
    var onAction: (GoalAction) -> Void
    var isCompleted: Bool
    
    // This will now track the selection, not a pixel offset
    @State private var selection: GoalAction = .finish
    @State private var isDragging = false
    
    var body: some View {
        GeometryReader { geometry in
            let segmentWidth = geometry.size.width / CGFloat(GoalAction.allCases.count)
            
            ZStack(alignment: .leading) {
                // Layer 1: The main glass background
                Capsule()
                    .fill(.regularMaterial)

                // Layer 2: The sliding selector pill
                Capsule()
                    .fill(.regularMaterial)
                    .frame(width: segmentWidth)
                    .overlay(Capsule().stroke(color(for: selection).opacity(isDragging ? 1.0 : 0.5), lineWidth: 2))
                    // ✅ The offset is now calculated simply based on the selected enum case
                    .offset(x: offset(for: selection, in: geometry.size))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selection)

                // Layer 3: The icons are on top
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
                        // As you drag, update the selection based on finger position
                        self.selection = action(for: value.location.x, in: geometry.size)
                    }
                    .onEnded { value in
                        isDragging = false
                        // Finalize the selection and perform the action
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
        // Add a tap gesture for individual button presses
        .onTapGesture {
            handleSelection(action: action)
        }
    }
    
    private func handleSelection(action: GoalAction) {
        if isCompleted && (action == .edit || action == .delete) { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        self.selection = action
        onAction(action)
        
        // After a moment, animate the visual selection back to the middle
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring()) {
                self.selection = .finish
            }
        }
    }
    
    // --- Helper Functions ---
    
    // Calculates the offset for the pill based on the selected enum case
    private func offset(for selection: GoalAction, in size: CGSize) -> CGFloat {
        let segmentWidth = size.width / CGFloat(GoalAction.allCases.count)
        switch selection {
        case .edit:   return 0
        case .finish: return segmentWidth
        case .delete: return segmentWidth * 2
        }
    }
    
    // Determines which enum case is selected based on the tap/drag location
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
