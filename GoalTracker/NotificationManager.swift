//
//  NotificationManager.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/16.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    // This function now accepts simple, safe data types.
    static func scheduleNotification(id: UUID, title: String, reminderDate: Date, reminderIsEnabled: Bool) {
        guard reminderIsEnabled else { return }
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("notification.title", comment: "")
        
        let localizedGoalTitle = title.contains("category.") ? NSLocalizedString(title, comment: "") : title
        let bodyFormat = NSLocalizedString("notification.body", comment: "")
        content.body = String(format: bodyFormat, localizedGoalTitle)
        
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for goal '\(title)' at \(reminderDate)")
            }
        }
    }
    
    // This function now accepts just the ID.
    static func cancelNotification(for goalID: UUID) {
        let center = UNUserNotificationCenter.current()
        let identifier = goalID.uuidString
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Attempted to cancel a notification for goal ID: \(identifier)")
    }
}
