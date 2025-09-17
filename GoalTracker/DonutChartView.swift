//
//  DonutChartView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//

import SwiftUI
import Charts

struct DonutChartView: View {
    let completionPercentage: Double
    let primaryColor: Color
    let secondaryColor: Color

    var body: some View {
        Chart {
            SectorMark(
<<<<<<< HEAD
                angle: .value(LocalizedStringKey("chart.label.completed"), completionPercentage * 360),
=======
                angle: .value("Completed", completionPercentage * 360),
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .foregroundStyle(primaryColor.gradient)
            .cornerRadius(5)

            SectorMark(
<<<<<<< HEAD
                angle: .value(LocalizedStringKey("chart.label.remaining"), (1.0 - completionPercentage) * 360),
=======
                angle: .value("Remaining", (1.0 - completionPercentage) * 360),
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .foregroundStyle(secondaryColor.gradient)
            .cornerRadius(5)
        }
        .chartLegend(.hidden)
        .frame(width: 200, height: 200)
        .overlay {
            Text("\(Int(completionPercentage * 100))%")
                .font(.title)
                .fontWeight(.semibold)
        }
        .padding(.bottom) // Adds some space after the chart
    }
}

struct DonutChartView_Previews: PreviewProvider {
    static var previews: some View {
        DonutChartView(completionPercentage: 0.75, primaryColor: .orange, secondaryColor: Color.gray.opacity(0.3))
    }
}
