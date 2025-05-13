//
//  GoalProgressView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/12.
//

// In GoalProgressView.swift
import SwiftUI
import Charts // Don't forget this import!

struct GoalProgressView: View {
    let goal: Goal
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView { // For title and dismiss button
            VStack(spacing: 20) {
                Text(goal.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                    .multilineTextAlignment(.center)

                Chart {
                    // Sector for completed portion
                    SectorMark(
                        angle: .value("Completed", goal.completionPercentage * 360), // Angle based on percentage
                        innerRadius: .ratio(0.618), // Makes it a donut
                        angularInset: 1.5 // Small gap between sectors
                    )
                    .foregroundStyle(Color.orange.gradient) // Color for completed part
                    .cornerRadius(5)

                    // Sector for remaining portion
                    SectorMark(
                        angle: .value("Remaining", (1.0 - goal.completionPercentage) * 360),
                        innerRadius: .ratio(0.618),
                        angularInset: 1.5
                    )
                    .foregroundStyle(Color.gray.opacity(0.3).gradient) // Color for remaining
                    .cornerRadius(5)
                }
                .chartLegend(.hidden) // Hide legend if it's self-explanatory
                .frame(width: 200, height: 200)
                .overlay {
                    Text("\(Int(goal.completionPercentage * 100))%")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .padding()

                if let startDate = goal.startDate {
                    Text("Started: \(startDate, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if let dueDate = goal.dueDate {
                    Text("Deadline: \(dueDate, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .navigationTitle("Goal Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Preview for GoalProgressView
struct GoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        GoalProgressView(
            goal: Goal(title: "Demo Goal with Progress",
                       startDate: Date(),
                       dueDate: Calendar.current.date(byAdding: .month, value: 1, to: Date()),
                       isCompleted: false,
                       completionPercentage: 0.65) // 65% complete for preview
        )
    }
}
