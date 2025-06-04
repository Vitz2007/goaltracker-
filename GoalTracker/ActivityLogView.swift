//
//  ActivityLogView.swift
//  GoalTracker
//
//  Created by AJ on 2025/05/19.
//
import SwiftUI

// Helper struct for ForEach, includes note
struct IdentifiableCheckInDisplay: Identifiable {
    let id: UUID // Use CheckInRecord's ID
    let date: Date
    let note: String?
}

struct ActivityLogView: View {
    // Ensure this expects [CheckInRecord]
    let checkIns: [CheckInRecord]
    let lastCheckInDisplayString: String

    // Definition of checkInMotivation
    private var checkInMotivation: String {
        let count = checkIns.count // Uses .count from the [CheckInRecord]
        if count == 0 {
            return "Ready for your first check-in?"
        } else if count < 3 {
            return "Good start! Let's build that momentum."
        } else if count < 7 {
            return "Nice consistency! Keep it up."
        } else if count < 15 {
            return "Great job! You're making solid progress."
        } else {
            return "Wow, \(count) check-ins! You're on a roll! 🔥"
        }
    }

    // This processes [CheckInRecord] for display
    private var displayableCheckIns: [IdentifiableCheckInDisplay] {
        let sortedAndReversed = checkIns.sorted(by: { $0.date > $1.date })
        let mappedItems = sortedAndReversed.map { record in
            IdentifiableCheckInDisplay(id: record.id, date: record.date, note: record.note)
        }
        // --- ADD THIS DEBUG PRINT ---
        print("DEBUG ActivityLogView: displayableCheckIns created. Count: \(mappedItems.count). First item note: \(mappedItems.first?.note ?? "N/A (or no items)")")
        for item in mappedItems {
            print("    Item ID: \(item.id), Date: \(item.date), Note: '\(item.note ?? "NIL")'")
        }
        // --- END DEBUG PRINT ---
        return mappedItems
    }

    // Date formatter
    private func abbreviatedFormattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yy, h:mm a"
        return formatter.string(from: date)
    }

    var body: some View {
        // Adding debut print for note
        let _ = print("DEBUG ActivityLogView: body evaluated. Received checkIns count: \(checkIns.count). First received note: \(checkIns.first?.note ?? "N/A (or no items)")")
        VStack(alignment: .leading, spacing: 10) {
            Text("Activity Log")
                .font(.title3)
                .fontWeight(.bold)

            HStack(alignment: .firstTextBaseline) {
                Text("Total Check-ins:")
                    .font(.body)
                Text("\(checkIns.count)") // Uses checkIns.count
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(checkIns.count >= 7 ? .green : (checkIns.count >= 3 ? .orange : .blue))
            }

            // 3. Using checkInMotivation
            Text(checkInMotivation)
                .font(.footnote)
                .foregroundColor(checkIns.count == 0 ? .orange : .secondary)
                .padding(.top, 1)

            Text("Last Check-in: \(lastCheckInDisplayString)")
                .font(.body)
                .padding(.top, 4)

            if !checkIns.isEmpty {
                Text("All Check-in Activity:")
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top, 12)

                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(displayableCheckIns) { displayItem in
                            VStack(alignment: .leading, spacing: 2) { // VStack for date and optional note
                                Text("• \(abbreviatedFormattedDate(displayItem.date))")
                                    .font(.body)
                                
                                if let note = displayItem.note, !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                                                    Text(note)
                                                                        .font(.caption)
                                                                        .foregroundColor(.gray)
                                                                        .padding(.leading, 18) // Indent note under the bullet point
                                                                }
                            }
                            .padding(.bottom, 4) // Adding a little space between entries
                        }
                    }
                }
                .frame(maxHeight: 150) // Adjust if needed
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Preview needs this updating to pass [CheckInRecord]
struct ActivityLogView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCheckInsWithNotes: [CheckInRecord] = [
            CheckInRecord(id: UUID(), date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, note: "Feeling great after this one!"),
            CheckInRecord(id: UUID(), date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, note: "A bit of a struggle, but pushed through."),
            CheckInRecord(id: UUID(), date: Date(), note: "") // Test with an empty string note
        ]
        let manySampleCheckIns: [CheckInRecord] = (0..<15).map { index in
            CheckInRecord(date: Calendar.current.date(byAdding: .day, value: -(index * 2), to: Date())!, note: index % 3 == 0 ? "Note for item \(index)" : nil)
        }

        // This VStack allows us to see multiple previews together in one canvas
        VStack(spacing: 30) {
            ActivityLogView(
                checkIns: manySampleCheckIns,
                lastCheckInDisplayString: "May 30, 2025, 11:00 AM"
            )
            .previewDisplayName("Many Check-ins")

            Divider()

            ActivityLogView(
                checkIns: sampleCheckInsWithNotes,
                lastCheckInDisplayString: "May 30, 2025, 11:00 AM"
            )
            .previewDisplayName("Few Check-ins with Notes")

            Divider()

            // Example for zero check-ins to test that state
            ActivityLogView(
                checkIns: [], // Empty array for zero check-ins
                lastCheckInDisplayString: "Never"
            )
            .previewDisplayName("Zero Check-ins")

        }
        .padding() // Apply padding to the whole VStack for better spacing of preview layout
        .previewLayout(.sizeThatFits) // Make  preview canvas fit the content size
    } // Closing brace for static var previews: some View
}
