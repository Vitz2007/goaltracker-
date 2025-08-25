//
//  ActivityHeatMapView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/07.
//

import SwiftUI

struct ActivityHeatmapView: View {
    // This view receives the set of active days from our ViewModel.
    let activeDays: Set<DateComponents>
    
    @AppStorage("app_language") private var appLanguage: String = "en"
    
    // We will display approximately the last 15 weeks of activity.
    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: appLanguage)
        
        // Get the single-letter symbols (e.g., S, M, T...)
                guard var symbols = formatter.veryShortStandaloneWeekdaySymbols else {
                    return []
                }
        
        // Adjust for the calendar's first day of the week (e.g., Sunday vs. Monday)
                let firstWeekday = Calendar.current.firstWeekday
                if firstWeekday > 1 {
                    // Reorder the array to start on the correct day
                    let daysToShift = symbols.prefix(firstWeekday - 1)
                    symbols.removeFirst(firstWeekday - 1)
                    symbols.append(contentsOf: daysToShift)
                }
                
                return symbols
            }
    
    private var dateRange: [Date] {
            var dates: [Date] = []
            let today = Date()
            let calendar = Calendar.current

        // Find the most recent Sunday to align our grid.
        guard let startOfTodayWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return []
        }
        
        // Create a date for each cell in our 15x7 grid.
        for i in 0..<(15 * 7) {
            if let date = calendar.date(byAdding: .day, value: -i, to: startOfTodayWeek) {
                dates.append(date)
            }
        }
        // Reverse so we go from past to present.
        return dates.reversed()
    }
    
    // The grid will have 7 columns for the days of the week.
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Section Header
            Text("dashboard.activity.title")
                .font(.title2.bold())
                .padding(.horizontal)

            // The main container for the heatmap
            VStack {
                // Weekday labels (Sun, Mon, etc.)
                HStack {
                    ForEach(weekdaySymbols, id: \.self) { day in
                        Text(day)
                            .font(.caption2)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // The grid of day cells
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(dateRange, id: \.self) { date in
                        let dayComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
                        let isActive = activeDays.contains(dayComponents)
                        
                        // Don't show cells for future dates.
                        let isFuture = date > Date()
                        
                        RoundedRectangle(cornerRadius: 3.0)
                            .fill(isFuture ? .clear : (isActive ? Color.accentColor : Color(uiColor: .systemGray5)))
                            .frame(height: 15)
                    }
                }
            }
            .padding()
            .background(Color(uiColor: .systemGray6), in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
        }
    }
}
