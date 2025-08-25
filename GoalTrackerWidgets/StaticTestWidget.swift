//
//  StaticTestWidget.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/08.
//

import WidgetKit
import SwiftUI

// 1. Define the provider for the static timeline
struct StaticProvider: TimelineProvider {
    // Provides a sample entry for the widget gallery
    func placeholder(in context: Context) -> StaticEntry {
        StaticEntry(date: Date())
    }

    // Provides the entry for the current state of the widget
    func getSnapshot(in context:Context, completion: @escaping (StaticEntry) -> ()) {
        let entry = StaticEntry(date: Date())
        completion(entry)
    }

    // Provides the timeline of entries
    func getTimeline(in context: Context, completion: @escaping (Timeline<StaticEntry>) -> ()) {
        let entry = StaticEntry(date: Date())
        // Create a timeline that never refreshes
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

// 2. Define the data for a single timeline entry
struct StaticEntry: TimelineEntry {
    let date: Date
}

// 3. Define the SwiftUI View for the widget
struct StaticTestWidgetEntryView : View {
    var entry: StaticProvider.Entry

    var body: some View {
        VStack {
            Text("widget.staticTest.title")
                .font(.headline)
            Text("widget.staticTest.subtitle")
                .font(.caption)
        }
        .containerBackground(.blue.gradient, for: .widget)
    }
}

// 4. Define the widget itself
struct StaticTestWidget: Widget {
    let kind: String = "StaticTestWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StaticProvider()) { entry in
            StaticTestWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("widget.staticTest.config.displayName")
        .description("widget.staticTest.config.description")
        .supportedFamilies([.systemSmall])
    }
}
