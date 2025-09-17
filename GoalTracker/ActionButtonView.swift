//
//  ActionButtonView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//

import SwiftUI
<<<<<<< HEAD
import Charts // For chart framework
=======
import Charts // for chart framwork
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484

// New struct for edit button
struct EditActionButtonView: View {
    @Binding var isTapped: Bool // For animation
<<<<<<< HEAD
    let action: () -> Void      // For 'action' property

    var body: some View {
        Button {
            action() // Call the passed-in action
=======
    let action: () -> Void     // << For 'action' property

    var body: some View {
        Button {
            action() // << Call the passed-in action
            // May want to toggle 'isTapped' for animation,
            // or handle animation based on the sheet's presentation.
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
        } label: {
            Image(systemName: "pencil.line")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color.blue.opacity(0.7))
                .cornerRadius(8)
<<<<<<< HEAD
                .symbolEffect(.bounce, value: isTapped)
        }
        .accessibilityLabel("accessibility.editButton.label") // ✅ ACCESSIBILITY
=======
                .symbolEffect(.bounce, value: isTapped) // isTapped needs to be toggled if used for animation
        }
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
    }
}

// New struct for progress button
struct ProgressActionButtonView: View {
    @Binding var isTapped: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
            isTapped.toggle()
        } label: {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 32))
                .foregroundColor(.white)
                .padding()
<<<<<<< HEAD
                .background(Color.orange.opacity(0.7))
                .cornerRadius(8)
                .symbolEffect(.pulse, value: isTapped)
        }
        .accessibilityLabel("accessibility.progressButton.label") // ✅ ACCESSIBILITY
=======
                .background(Color.orange.opacity(0.7)) // Orange button
                .cornerRadius(8)
                .symbolEffect(.pulse, value: isTapped)
        }
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
    }
}

// New struct for finish action button
<<<<<<< HEAD
struct FinishActionButtonView: View {
    var isCompleted: Bool
    @Binding var scale: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if isCompleted {
                Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                    .font(.system(size: 65))
                    .foregroundColor(.teal)
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 59.5))
                    .foregroundColor(.green)
            }
        }
        .scaleEffect(scale)
        // ✅ ACCESSIBILITY (Changes based on state)
        .accessibilityLabel(isCompleted ? "accessibility.markIncomplete.label" : "accessibility.markComplete.label")
=======
import SwiftUI

struct FinishActionButtonView: View {
    // This new property checks the goal's status
    var isCompleted: Bool

    @Binding var scale: CGFloat
    let action: () -> Void
    
    // Easy access to adjusting icon size
    // private let iconSize: CGFloat = 55.5

    var body: some View {
        Button(action: action) {
            // This 'if' statement dynamically changes the button's appearance
            if isCompleted {
                // Re-open icon
                    Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                    .font(.system(size: 65))
                        .foregroundColor(.teal)
                
            } else {
                // The "Finish" icon
                    Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 59.5))
                        .foregroundColor(.green)
                }
            }
        .scaleEffect(scale)
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
    }
}

// New struct for delete button
struct DeleteActionButtonView: View {
    @Binding var isTapped: Bool // For ShakeEffect
    let action: () -> Void

    var body: some View {
        Button {
            action()
<<<<<<< HEAD
            isTapped.toggle() // Triggers the shake if modifier depends on it
=======
            isTapped.toggle() // This triggers the shake if modifier depends on it
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
        } label: {
            Image(systemName: "trash")
                .font(.system(size: 27))
                .foregroundColor(.white)
                .padding()
<<<<<<< HEAD
                .background(Color.gray.opacity(0.8)) // Gray button
                .cornerRadius(8)
        }
        .accessibilityLabel("accessibility.deleteButton.label") // ✅ ACCESSIBILITY
=======
                .background(Color.gray.opacity(0.8)) // Gray button bg
                .cornerRadius(8)
                .modifier(ShakeEffect(animatableData: isTapped ? 1 : 0))
        }
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
    }
}

// New struct for streak badges
struct StreakBadgeView: View {
    let streakCount: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
            Text("\(streakCount)")
        }
        .font(.caption.weight(.bold))
        .foregroundColor(.orange)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.orange.opacity(0.2))
        .clipShape(Capsule())
<<<<<<< HEAD
        // ✅ ACCESSIBILITY (Combines the label and value for VoiceOver)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("accessibility.streak.label")
=======
    }
}

// New struct for charts
struct ActivityBarChartView: View {
    let activityData: [DayActivity]
    
    // Formatter to get the first letter of the weekday ie: M for Monday
    private var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // Letter E gives "Mon", "Tue", etc
        return formatter
    }
    
    var body: some View {
        Chart(activityData) { day in
            // Create bar representing each day
            // If checkInCount > 0, the bar goes up, if 0 show tiny line
            BarMark (
                x: .value("Date", day.date, unit: .day),
                y: .value("Check-ins", day.checkInCount > 0 ? 1 : 0) // concerned about check-ins only, not frequency of check-ins
            )
            .foregroundStyle(day.checkInCount > 0 ? Color.green.gradient : Color.gray.opacity(0.3).gradient)
            .cornerRadius(4)
        }
        
        // Add styling to chart
        .chartYAxis(.hidden) // Hide 0.0, 0.5, 1.0 labels on the side
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                // Add a line and a label for each day mark
                AxisGridLine()
                AxisTick()
                // Get the date for the current mark
                if let date = value.as(Date.self) {
                    // Formatting to get the day initial (ie: "M")
                    let dayInitial = String(weekdayFormatter.string(from: date).first!)
                    AxisValueLabel(dayInitial)
                        .font(.caption)
                }
            }
        }
        .frame(height: 50) // Some fixed height
        .padding(.top)
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
    }
}
