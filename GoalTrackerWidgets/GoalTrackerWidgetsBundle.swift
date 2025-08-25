//
//  GoalTrackerWidgetsBundle.swift
//  GoalTrackerWidgets
//
//  Created by AJ on 2025/07/03.
//

import WidgetKit
import SwiftUI

@main
struct GoalTrackerWidgetsBundle: WidgetBundle {
    var body: some Widget {
        GoalTrackerWidgets()
        GoalTrackerWidgetsControl()
        GoalTrackerWidgetsLiveActivity()
        StaticTestWidget()
    }
}
