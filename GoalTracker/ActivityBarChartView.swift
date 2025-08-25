//
//  ActivityChartView.swift
//  GoalTracker
//
//  Created by AJ on 2025/07/02.
//

// In ActivityChartView.swift

import SwiftUI
import Charts

struct ActivityBarChartView: View {
    // The view now declares the data it needs to be passed.
    let activityData: [DayActivity]
    
    // Get current language setting for the app
    @AppStorage("app_language") private var appLanguage: String = "en"
    
    // Formatter to get the first letter of the weekday (e.g., M for Monday) & is using app's locale to be language-aware
    private var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: appLanguage) // Sets the locale
        formatter.dateFormat = "E"
        return formatter
    }
    
    var body: some View {
        Chart(activityData) { day in
            // Create a bar representing each day
            BarMark (
                x: .value(LocalizedStringKey("chart.date.label"), day.date, unit: .day),
                y: .value(LocalizedStringKey("chart.checkins.label"), day.checkInCount > 0 ? 1 : 0)
            )
            .foregroundStyle(day.checkInCount > 0 ? Color.green.gradient : Color.gray.opacity(0.3).gradient)
            .cornerRadius(4)
        }
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                AxisTick()
                if let date = value.as(Date.self) {
                    if let dayInitial = weekdayFormatter.string(from: date).first {
                        AxisValueLabel(String(dayInitial))
                            .font(.caption)
                    }
                }
            }
        }
        .frame(height: 50)
        .padding(.top)
    }
}
