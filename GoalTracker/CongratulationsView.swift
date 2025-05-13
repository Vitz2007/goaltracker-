//
//  CongratulationsView.swift
//  GoalTracker
//
//  Created by AJ on 2025/04/26.
//

import SwiftUI

struct CongratulationsView: View {
     let goal: Goal // Receive the completed goal

    var body: some View {
        VStack(spacing: 30) {
             Text("🎉 Congratulations! 🎉")
                 .font(.largeTitle)

             Text("You completed your goal:")
                 .font(.title2)

             Text(goal.title)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)


             // TODO: Add suggestions for next actions later
             Text("What's next?")
                .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle("Goal Achieved!")
    }
}
