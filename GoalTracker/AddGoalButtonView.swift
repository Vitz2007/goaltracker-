//
//  AddGoalButtonView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//
import SwiftUI

struct AddGoalButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 32))
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 3)
        }
        .padding(.bottom) // Padding for the button
    }
}
