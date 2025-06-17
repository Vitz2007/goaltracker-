//
//  NotificationManager.swift
//  GoalTracker
//
//  Created by AJ on 2025/06/16.
//

import SwiftUI
import UserNotifications

struct NotificationManager {
    
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
}
