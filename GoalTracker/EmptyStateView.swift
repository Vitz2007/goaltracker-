//
//  EmptyStateView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/08.
//
<<<<<<< HEAD

=======
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
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
<<<<<<< HEAD
                Image(systemName: "leaf.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.green)
=======
                Image(systemName: "flag.checkered.2.crossed")
                    .font(.system(size: 60))
                    .foregroundStyle(.teal)
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                
                // A subtle accent
                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundStyle(.yellow)
                    .offset(x: 35, y: -35)
                    .opacity(0.8)
            }
            
            // An engaging and encouraging text
            VStack(spacing: 12) {
<<<<<<< HEAD
                            Text("emptyState.title")
=======
                            Text("Your Journey Begins!")
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)

<<<<<<< HEAD
                            Text("emptyState.subtitle")
=======
                            Text("Every great accomplishment starts with a single step. Tap the '+' button to create your first goal.")
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
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
<<<<<<< HEAD
                .navigationTitle("contentView.title")
=======
                .navigationTitle("My Goals")
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
