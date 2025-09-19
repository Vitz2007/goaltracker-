//
//  CongratulationsView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/26.
//

import SwiftUI

struct CongratulationsView: View {
    var body: some View {
        if CelebrationManager.shared.isCelebrating {
            Rectangle()
                .fill(.black.opacity(0.5))
                .ignoresSafeArea()
                .transition(.opacity)
            
            VStack(spacing: 20) {
                Text("congrats.title")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundStyle(.green)
                
                if let goalTitle = CelebrationManager.shared.lastCompletedGoal?.title {
                    Text(LocalizedStringKey(goalTitle))
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                
                Button("congrats.dismissButton") {
                    withAnimation {
                        CelebrationManager.shared.isCelebrating = false
                    }
                }
                .font(.headline)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(.green, in: Capsule())
                .foregroundStyle(.white)
                .padding(.top)
            }
            .padding(30)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
            .padding(40)
            .transition(.scale.combined(with: .opacity))
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        
        CongratulationsView()
            .onAppear {
                // This now correctly matches the initializer in Goal.swift
                let sampleGoal = Goal(
                    title: "Run a 5K Without Stopping",
                    dueDate: .now,
                    targetCheckIns: 10
                )
                CelebrationManager.shared.start(goal: sampleGoal)
            }
    }
}
