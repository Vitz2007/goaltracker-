//
//  GoalDetailView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/17.
//

import SwiftUI

struct GoalDetailView: View {
    // State for the goal data itself & Callbacks
    @State var goal: Goal
    var onUpdate: (Goal) -> Void
    var onDelete: (UUID) -> Void
    
    //State for presenting sheets, alerts, and navigation
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var navigateToProgress: false
    @State private var naviagateToCongrats: false

    //State variables for animations (re-added from original)
    @State private var editButtonTapped = false // For Edit button bounce
        @State private var progressButtonTapped = false // For Progress button pulse
        @State private var finishButtonScale: CGFloat = 1.0 // For Finish button scale
        @State private var deleteButtonOffset: CGFloat = 0 // For Delete button offset shake
    var body: some View {
        VStack {
            Text(goal.title)
                .font(.largeTitle)
                .padding()

            Spacer()

            HStack {
                Button {
                    print("Edit tapped for \(goal.title)")
                    editButtonTapped.toggle()
                } label: {
                    Image(systemName: "pencil.line")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue.opacity(0.5))
                        .cornerRadius(8)
                        .symbolEffect(.bounce, value: editButtonTapped)
                }

                Spacer()

                Button {
                    print("Progress tapped for \(goal.title)")
                    progressButtonTapped.toggle()
                } label: {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange.opacity(0.7))
                        .cornerRadius(8)
                        .symbolEffect(.pulse, value: progressButtonTapped)
                }

                Spacer()

                Button {
                    print("Finish tapped for \(goal.title)")
                    withAnimation(.easeInOut(duration: 0.1)) {
                        finishButtonScale = 0.9
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            finishButtonScale = 1.0
                        }
                    }
                } label: {
                    Image(systemName: "checkmark.seal")
                        .font(.system(size: 27))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green.opacity(0.6))
                        .cornerRadius(8)
                        .scaleEffect(finishButtonScale)
                }

                Spacer()

                Button {
                    print("Delete tapped for \(goal.title)")
                    withAnimation(.easeInOut(duration: 0.05)) {
                        deleteButtonOffset = -3
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.05)) {
                            deleteButtonOffset = 3
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.easeInOut(duration: 0.05)) {
                                deleteButtonOffset = -3
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeInOut(duration: 0.05)) {
                                    deleteButtonOffset = 3
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    withAnimation(.easeInOut(duration: 0.05)) {
                                        deleteButtonOffset = 0
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 27))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(8)
                        .offset(x: deleteButtonOffset)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Goal Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GoalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GoalDetailView(goal: Goal(title: "Sample Goal", dueDate: Date()))
    }
}
