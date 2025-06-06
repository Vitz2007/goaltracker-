//
//  UndoCheckInConfirmationView.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/06.
//
import SwiftUI

struct UndoCheckInConfirmationView: View {
    let message: String
    let onUndo: () -> Void
    let onDismiss: () -> Void // KEEP for future use
    
    // New @State to create and track vertical drag offset
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        HStack {
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.vertical, 8)
            
            Spacer()
            
            Button("Undo") {
                onUndo()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue.cornerRadius(8)) // Adding corner radius to the button
        }
        .padding() // More padding for a better appearance
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.8))
        .cornerRadius(12)
        .shadow(radius: 5)
        
        // Add drag offet to move the view
        .offset(y: dragOffset)
        
        // Add drag gesture
        .gesture(
            DragGesture()
                .onChanged { value in
                    // When user drags, update offset
                    // Use max(0,...) because only downward drags
                    if value.translation.height > 0 {
                        self.dragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    // If user lets go, check if dragged more than 50 points downward
                    if value.translation.height > 50 {
                        // If yes, call the dismiss action. Timer won't trigger
                        // and view will disappear from GoalDetailView
                        onDismiss()
                    } else {
                        // If not, user hasn't swiped down far enough
                        // Animate the view snapping back to original position
                        withAnimation(.spring()) {
                            self.dragOffset = 0
                        }
                    }
                    
                }
        )
        
    }
}
