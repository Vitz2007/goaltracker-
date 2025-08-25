//
//  ConfettiView.swift
//  GoalTrackerv2
//
//  Created by AJ on 2025/06/24.
//

import SwiftUI

// A single piece of confetti that knows how to animate itself.
struct ConfettiLeaf: View {
    @State private var isAnimating = false
    let delay: Double

    var body: some View {
        Image(systemName: "leaf.fill")
            .foregroundStyle(Color.green, Color.teal)
            .font(.system(size: 20))
            .opacity(isAnimating ? 0 : 1)
            .offset(y: isAnimating ? 400 : 0) // Fall downwards
            .rotationEffect(.degrees(isAnimating ? .random(in: -180...180) : 0))
            .animation(
                .easeOut(duration: 1.5).delay(delay),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

// The main view that contains and positions all the confetti leaves.
struct ConfettiView: View {
    @Binding var isCelebrating: Bool
    let startPoint: CGPoint?
    
    @State private var localStartPoint: CGPoint?

    var body: some View {
        // ✅ 1. Wrap the ZStack in a GeometryReader to get the container size
        GeometryReader { proxy in
            ZStack {
                if isCelebrating {
                    ForEach(0..<50) { i in
                        ConfettiLeaf(delay: .random(in: 0...0.5))
                            // ✅ 2. Use the proxy's size instead of UIScreen.main
                            .position(x: localStartPoint?.x ?? proxy.size.width / 2, y: localStartPoint?.y ?? -50)
                            .offset(x: .random(in: -20...20), y: .random(in: -20...20))
                    }
                }
            }
        }
        .onChange(of: isCelebrating) { oldValue, newValue in
            if !newValue { return }
            
            self.localStartPoint = self.startPoint
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isCelebrating = false
            }
        }
        .allowsHitTesting(false)
    }
}
