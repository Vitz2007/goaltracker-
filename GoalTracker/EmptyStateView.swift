//
//  EmptyStateView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/08.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack { // Wrap in VStack to use Spacer effectively
            Spacer() // Pushes content to center
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
                .frame(width: 250, height: 55)
                .overlay(
                    Text("No Goals Yet!") // Changed text slightly for clarity
                        .foregroundColor(.gray)
                        .font(.title2)
                )
                .padding() // Inner padding for text from RoundedRect edge
            // .padding(.top, 55) // This padding might be better applied where EmptyStateView is used
            Spacer() // Pushes content to center
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure VStack takes available space
    }
}
