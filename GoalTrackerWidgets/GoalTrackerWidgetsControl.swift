//
//  GoalTrackerWidgetsControl.swift
//  GoalTrackerWidgets
//
//  Created by AJ on 2025/07/03.
//

import AppIntents
import SwiftUI
import WidgetKit

struct GoalTrackerWidgetsControl: ControlWidget {
    static let kind: String = "com.kioshi.GoalTracker.GoalTrackerWidgets"

    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: Provider()
        ) { value in
            ControlWidgetToggle(
                LocalizedStringKey("widget.control.toggle.startTimer"),
                isOn: value.isRunning,
                action: StartTimerIntent(value.name)
            ) { isRunning in
                Label(isRunning ? LocalizedStringKey("common.on") : LocalizedStringKey("common.off"), systemImage: "timer")
            }
        }
        .displayName(LocalizedStringResource("widget.control.displayName"))
               .description(LocalizedStringResource("widget.control.description"))
           }
       }

extension GoalTrackerWidgetsControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }

    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            GoalTrackerWidgetsControl.Value(isRunning: false, name: configuration.timerName)
        }

        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let isRunning = true // Check if the timer is running
            return GoalTrackerWidgetsControl.Value(isRunning: isRunning, name: configuration.timerName)
        }
    }
}

struct TimerConfiguration: ControlConfigurationIntent {
    static let title: LocalizedStringResource = "intent.timerConfig.title"

    @Parameter(title: "intent.timerConfig.param.timerName.title", default: "intent.timerConfig.param.timerName.default")
        var timerName: String
    }

struct StartTimerIntent: SetValueIntent {
    static let title: LocalizedStringResource = "intent.startTimer.title"

    @Parameter(title: "intent.timerConfig.param.timerName.title")
       var name: String

    @Parameter(title: "intent.startTimer.param.isRunning.title")
       var value: Bool

    init() {}

    init(_ name: String) {
        self.name = name
    }

    func perform() async throws -> some IntentResult {
        // Start the timer…
        return .result()
    }
}
