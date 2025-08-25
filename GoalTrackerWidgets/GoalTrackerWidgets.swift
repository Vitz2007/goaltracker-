//
//  GoalTrackerWidgets.swift
//  GoalTrackerWidgets
//
//  Created by AJ on 2025/07/03.
//

import WidgetKit
import SwiftUI
import SwiftData

// This is the "brain" of the widget. It provides the data for the timeline.
// This is the "brain" of the widget.
// In your GoalTrackerWidgets.swift file

struct Provider: AppIntentTimelineProvider {
    
    @MainActor
    private func createTimelineEntry() -> SimpleEntry {
        let allGoals = DataManager.shared.load()
        let activeGoals = allGoals.filter { !$0.isCompleted && $0.dueDate != nil }
        let nextGoal = activeGoals.sorted { $0.dueDate! < $1.dueDate! }.first

        return SimpleEntry(date: .now, goal: nextGoal)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        let title = NSLocalizedString("widget.placeholder.title", comment: "")
        let placeholderGoal = Goal(title: title, dueDate: .now)
        return SimpleEntry(date: .now, goal: placeholderGoal)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        // ✅ ADD await HERE
        await createTimelineEntry()
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        // ✅ AND ADD await HERE
        let entry = await createTimelineEntry()
        
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        return timeline
    }
}
    
    // The old createTimelineEntry() function is no longer needed for this workaround.


// This struct holds the data for a single point in time for the widget.
struct SimpleEntry: TimelineEntry {
    let date: Date
    let id: String? // Using simple types for Sendable safety
    let title: String?
    let dueDate: Date?
    let isCompleted: Bool?
    let completionPercentage: Double?

    // An initializer to easily convert a Goal into a SimpleEntry.
    init(date: Date, goal: Goal?) {
        self.date = date
        self.id = goal?.id.uuidString
        self.title = goal?.title
        self.dueDate = goal?.dueDate
        self.isCompleted = goal?.isCompleted
        self.completionPercentage = goal?.completionPercentage
    }

    // A separate initializer for creating a placeholder manually.
    init(date: Date, title: String?, dueDate: Date?, isCompleted: Bool?, completionPercentage: Double?) {
        self.date = date
        self.id = nil
        self.title = title
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.completionPercentage = completionPercentage
    }
    
    static func noGoals() -> SimpleEntry {
        return SimpleEntry(date: .now, title: nil, dueDate: nil, isCompleted: nil, completionPercentage: nil)
    }
}

// This is the SwiftUI view that displays the widget's content.
struct GoalTrackerWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
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
                
                // Goal Info
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

                // Interactive Button
                Button(intent: CheckInIntent(goalID: goalID)) {
                    Label("intent.checkin.title", systemImage: "checkmark.circle.fill")
                }
                .tint(Color.green.gradient)
                
            } else {
                // This part is for when there are no goals.
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
        .configurationDisplayName(LocalizedStringKey("widget.config.displayName"))
                .description(LocalizedStringKey("widget.config.description"))
                .supportedFamilies([.systemSmall, .systemMedium])
            }
        }
