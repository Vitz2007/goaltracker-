//
//  EmptyStateView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/08.
//
import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 24) { // Wrap in VStack to allow Spacer() to work
            Spacer() // Pushes content towards center if VStack fills space
            
            ZStack {
                // A more subtle background shape
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 140, height: 140)
                
                // The main icon
                Image(systemName: "flag.checkered.2.crossed")
                    .font(.system(size: 60))
                    .foregroundStyle(.teal)
                
                // A subtle accent
                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundStyle(.yellow)
                    .offset(x: 35, y: -35)
                    .opacity(0.8)
            }
            
            // An engaging and encouraging text
            VStack(spacing: 12) {
                            Text("Your Journey Begins!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)

                            Text("Every great accomplishment starts with a single step. Tap the '+' button to create your first goal.")
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 40) // Keep text from getting too wide
                        
                        Spacer()
                        Spacer() // Using two spacers pushes the content a bit higher than using true center
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        // Best to preview within a NavigationView to simulate how it looks in your actual app.
        NavigationView {
            EmptyStateView()
                .navigationTitle("My Goals")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
