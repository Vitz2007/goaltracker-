//
//  NotificationManager.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/16.
//

<<<<<<< HEAD
import Foundation
=======
import SwiftUI
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
import UserNotifications

struct NotificationManager {
    
<<<<<<< HEAD
    // ✅ CHANGED: This function now accepts simple, safe data types.
    static func scheduleNotification(id: UUID, title: String, reminderDate: Date, reminderIsEnabled: Bool) {
        guard reminderIsEnabled else { return }
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("notification.title", comment: "")
        
        let localizedGoalTitle = NSLocalizedString(title, comment: "")
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
    
    // ✅ CHANGED: This function now accepts just the ID.
    static func cancelNotification(for goalID: UUID) {
        let center = UNUserNotificationCenter.current()
        let identifier = goalID.uuidString
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Attempted to cancel a notification for goal ID: \(identifier)")
=======
    // Function to schedule a notification for specific goals
    static func scheduleNotification(for goal: Goal) {
        // Enable reminder for the goal
        guard goal.reminderIsEnabled else { return }
        
        let center = UNUserNotificationCenter.current()
        
        // Content of the notification aka what the user sees
        let content = UNMutableNotificationContent()
        content.title = "Goal Reminder"
        content.body = "Don't forget to work on your goal: \(goal.title)"
        content.sound = .default
        
        // Trigger for notifications
        // Extract date details ie: day, month, year, etc from goal's reminderDate
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: goal.reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: goal.id.uuidString, content: content, trigger: trigger)
        
        // Add the request to notification center
        center.add(request) { error in
            if let error = error {
                print("Error scheduleing notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for goal '\(goal.title)' at \(goal.reminderDate)")
            }
        }
    }
    // Place holder for function to cancel notifications here ===
    static func cancelNotification(for goal: Goal) {
        let center = UNUserNotificationCenter.current()
        // Cancel a notification by providing the its unique id aka goal's id
        let identifier = goal.id.uuidString
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Attempted to cancel a notification for goal: \(goal.title) (ID: \(identifier))")
>>>>>>> a5299dab53fdf2a51098c77d51abdc51565d4484
    }
}
