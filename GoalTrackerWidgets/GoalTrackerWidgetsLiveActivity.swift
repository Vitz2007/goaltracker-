//
//  GoalTrackerWidgetsLiveActivity.swift
//  GoalTrackerWidgets
//
//  Created by AJ on 2025/07/03.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GoalTrackerWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GoalTrackerWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GoalTrackerWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                let greetingFormat = NSLocalizedString("liveactivity.lockScreen.greeting", comment: "")
                Text(String(format: greetingFormat, context.state.emoji))
                            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("liveActivity.dynamicIsland.expanded.leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("liveActivity.dynamicIsland.expanded.trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    let bottomFormat = NSLocalizedString("liveActivity.dynamicIsland.expanded.bottom", comment: "")
                                        Text(String(format: bottomFormat, context.state.emoji))
                                    }
            } compactLeading: {
                Text("liveActivity.dynamicIsland.compact.leading")
            } compactTrailing: {
                let trailingFormat = NSLocalizedString("liveActivity.dynamicIsland.compact.trailing", comment: "")
                                Text(String(format: trailingFormat, context.state.emoji))
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GoalTrackerWidgetsAttributes {
    fileprivate static var preview: GoalTrackerWidgetsAttributes {
        GoalTrackerWidgetsAttributes(name: "World")
    }
}

extension GoalTrackerWidgetsAttributes.ContentState {
    fileprivate static var smiley: GoalTrackerWidgetsAttributes.ContentState {
        GoalTrackerWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GoalTrackerWidgetsAttributes.ContentState {
         GoalTrackerWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GoalTrackerWidgetsAttributes.preview) {
   GoalTrackerWidgetsLiveActivity()
} contentStates: {
    GoalTrackerWidgetsAttributes.ContentState.smiley
    GoalTrackerWidgetsAttributes.ContentState.starEyes
}
