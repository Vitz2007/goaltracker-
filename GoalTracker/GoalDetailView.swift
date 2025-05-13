//
//  GoalDetailView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/17.
//

import SwiftUI

struct GoalDetailView: View {
    @State private var showingProgressSheet = false // enable show
    progress sheet
    // State for the goal data itself & Callbacks
    @State var goal: Goal
    var onUpdate: (Goal) -> Void
    var onDelete: (UUID) -> Void
    @State private var editButtonTapped = false
    @State private var progressButtonTapped = false
    @State private var finishButtonScale: CGFloat = 1.0
    @State private var deleteButtonOffset: CGFloat = 0
    @State private var deleteButtonTapped = false // Keep for delete animation logic

    // Define background color (Ex: Light Stone Gray)
    let bottomBarBackgroundColor = Color.gray.opacity(0.1) // Or Color(white: 0.95), or a custom color

    var body: some View {
        VStack {
            Text(goal.title)
                .font(.largeTitle)
                .padding()

            Spacer() // Pushes the HStack to the bottom

            // HStack containing the buttons
            HStack {
                Button {
                    print("Edit tapped for \(goal.title)")
                    editButtonTapped.toggle()
                    // Add actual edit action
                } label: {
                    Image(systemName: "pencil.line")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(8)
                        .symbolEffect(.bounce, value: editButtonTapped)
                }

                Spacer()

                Button {
                    print("Progress tapped for \(goal.title)")
                    progressButtonTapped.toggle()
                    // Add actual progress action
                } label: {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange.opacity(0.7)) // Orange button
                        .cornerRadius(8)
                        .symbolEffect(.pulse, value: progressButtonTapped)
                }

                Spacer()

                Button {
                    print("Finish tapped for \(goal.title)")
                    // Simple animation
                    
                     withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                         finishButtonScale = 1.2 // Scale up
                     }
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                         withAnimation(.spring()) {
                             finishButtonScale = 1.0 // Scale back
                         }
                     }
                    // Add actual finish action
                } label: {
                    Image(systemName: "checkmark.seal")
                        .font(.system(size: 27))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green.opacity(0.6)) // Green button bg
                        .cornerRadius(8)
                        .scaleEffect(finishButtonScale)
                }


                Spacer()

                Button {
                    print("Delete tapped for \(goal.title)")
                        deleteButtonTapped.toggle()
                        onDelete(goal.id)
                    
                } label: {
                     Image(systemName: "trash")
                         .font(.system(size: 27))
                         .foregroundColor(.white) //
                         .padding()
                         .background(Color.gray.opacity(0.8)) // Gray button bg
                         .cornerRadius(8)
                    
                         .modifier(ShakeEffect(animatableData: deleteButtonTapped ? 1 : 0))

                }

            } // End of HStack content
            .padding(.horizontal) // Give buttons space from screen edges
            .padding(.top, 10) // Give space above icons within the bar
            .padding(.bottom) // Give space from bottom edge
            // ***** ADD THE BACKGROUND HERE *****
            .frame(maxWidth: .infinity) // Make the background conceptually span width
            .background(bottomBarBackgroundColor)
            // Optional: If you want the color to go right to the screen edge:
            // .ignoresSafeArea(.container, edges: .bottom)

        } // End of VStack
        .navigationTitle("Goal Details")
        .navigationBarTitleDisplayMode(.inline)

    }
}

// Simple Shake Effect Modifier (Example)
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 5 // How far to shake
    var shakesPerUnit = 3 // How many shakes
    var animatableData: CGFloat // Value to animate (e.g., 0 to 1)

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct GoalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GoalDetailView(
                
                goal: Goal(title: "Sample Preview Goal", dueDate: Date(), isCompleted: false),
                onUpdate: { updatedGoalFromPreview in
                    print("Preview: Goal updated to: \(updatedGoalFromPreview.title)")
                },
                onDelete: { goalIdFromPreview in
                    print("Preview: Delete goal with ID: \(goalIdFromPreview)")
                }
            )
        }
    }
}
