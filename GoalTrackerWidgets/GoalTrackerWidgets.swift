//
//  GoalTrackerWidgets.swift
//  GoalTrackerWidgets
//
//  Created by AJ on 2025/07/03.
//

import WidgetKit
import SwiftUI
import AppIntents

// This is the "brain" of the widget.
struct Provider: AppIntentTimelineProvider {
    
    @MainActor
    private func createTimelineEntry() -> SimpleEntry {
        let nextGoal = DataManager.shared.loadNextGoal()
        return SimpleEntry(date: .now, goal: nextGoal)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        let title = NSLocalizedString("widget.placeholder.title", comment: "")
        let placeholderGoal = Goal(title: title, dueDate: .now)
        return SimpleEntry(date: .now, goal: placeholderGoal)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        await createTimelineEntry()
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = await createTimelineEntry()
        
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        return timeline
    }
}


// This struct holds the data for the widget.
struct SimpleEntry: TimelineEntry {
    let date: Date
    let id: String?
    let title: String?
    let dueDate: Date?
    let isCompleted: Bool?
    let completionPercentage: Double?

    init(date: Date, goal: Goal?) {
        self.date = date
        self.id = goal?.id.uuidString
        self.title = goal?.title
        self.dueDate = goal?.dueDate
        self.isCompleted = goal?.isCompleted
        self.completionPercentage = goal?.completionPercentage
    }
    
    static func noGoals() -> SimpleEntry {
        return SimpleEntry(date: .now, goal: nil)
    }
}

// This is the SwiftUI view that displays the widget's content.
struct GoalTrackerWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        // ✅ Wrap the entire view in a Link if a goal exists to allow deep linking
        if let goalIDString = entry.id, let url = URL(string: "goaltracker://goal?id=\(goalIDString)") {
            Link(destination: url) {
                widgetContent
            }
            .tint(.primary) // Ensure the content doesn't get colored like a link
        } else {
            // If there's no goal, just show the content without a link
            widgetContent
        }
    }
    
    // This private property holds the actual UI for the widget
    private var widgetContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("widget.header.nextGoal")
                .font(.caption)
                .foregroundStyle(.secondary)
                .bold()

            if let title = entry.title,
               let dueDate = entry.dueDate,
               let isCompleted = entry.isCompleted,
               let completionPercentage = entry.completionPercentage,
               let goalIDString = entry.id,
               let goalID = UUID(uuidString: goalIDString) {
                
                VStack(alignment: .leading) {
                    Text(LocalizedStringKey(title))
                        .font(.headline)
                        .strikethrough(isCompleted)
                    
                    ProgressView(value: completionPercentage)
                        .padding(.vertical, 2)
                    
                    let formatString = NSLocalizedString("widget.label.due", comment: "")
                    let dueDateFormatted = dueDate.formatted(date: .numeric, time: .omitted)
                    Text(String(format: formatString, dueDateFormatted))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(intent: CheckInIntent(goalID: goalID)) {
                    Label("intent.checkin.title", systemImage: "checkmark.circle.fill")
                }
                .tint(Color.green.gradient)
                
            } else {
                Spacer()
                Text("widget.emptyState.title")
                    .font(.headline)
                Text("widget.emptyState.subtitle")
                    .font(.caption)
                Spacer()
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}


// This is the main configuration for the widget.
struct GoalTrackerWidgets: Widget {
    let kind: String = "GoalTrackerWidgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            GoalTrackerWidgetsEntryView(entry: entry)
        }
        // ✅ CORRECTED: These modifiers require LocalizedStringResource
        .configurationDisplayName(LocalizedStringResource("widget.config.displayName"))
        .description(LocalizedStringResource("widget.config.description"))
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
