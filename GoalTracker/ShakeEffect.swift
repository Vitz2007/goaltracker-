//
//  ShakeEffect.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/26.
//

import SwiftUI

// A GeometryEffect that creates a shaking animation.
// By placing it in its own file, it can be used by any view in the app.
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 5
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}
