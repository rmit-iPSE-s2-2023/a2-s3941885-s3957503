//
//  NotificationManager.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 4/10/2023.
//



import Foundation
import UserNotifications


 /**
  `NotificationManager` is responsible for scheduling task reminder notifications in the app.
  
  ## Overview:
  `NotificationManager` provides a set of functions to schedule local notifications for upcoming tasks. It uses the UserNotifications framework to set up and deliver reminders to the user.
  
  ## Usage:
  To use the `NotificationManager` in your SwiftUI view, follow these steps:
  1. Call the `scheduleAlert(taskName:selectedDate:selectedTime:selectedAlertOption:)` function with the required parameters to schedule a notification.
  
  Here's an example of how to use it:
  ```swift
  let taskName = "Assignment 02"
  let selectedDate = Date() // The date when the task is scheduled
  let selectedTime = Date() // The time when the task is scheduled
  let selectedAlertOption = "5 Minutes Before" // Choose from available options
  NotificationManager.scheduleAlert(taskName: taskName, selectedDate: selectedDate, selectedTime: selectedTime, selectedAlertOption: selectedAlertOption)
  ```
  ##Body:
  `NotificationManager` primarily consists of a set of two functions for scheduling task reminder notifications.
  
  ##Function:
  `scheduleAlert(taskName:selectedDate:selectedTime:selectedAlertOption:)`:
  This function schedules a local notification for an upcoming task. It takes the task name, the date, the time, and the alert option as parameters to set up the notification. The alert option allows you to customize when the notification should be delivered, such as 5 minutes before, 15 minutes before, etc.
  `requestingNotification(date: Date, content: UNMutableNotificationContent)`:
  This function is responsible for requesting a local notification. It takes a date and context of the notification as parameter for requesting a notification.
 **/

class NotficationManager{
    
    static func scheduleAlert(taskName: String, selectedDate: Date, selectedTime: Date, selectedAlertOption: String){
        
        //Accessing to the content of UserNotification framework in SwiftUI to set content of the notification.
        let content = UNMutableNotificationContent()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        content.title = "iShedule Reminder"
        let eventTime = dateFormatter.string(from: selectedTime)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let eventDate = dateFormatter.string(from: selectedDate)
        content.body = "Upcoming Task: \(taskName) on \(eventDate) at \(eventTime)"
        content.sound = UNNotificationSound.default
        
        
        //Joining the selected date and time into a single Date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
        let joinedSelectedDate = calendar.date(bySettingHour: timeComponents.hour ?? 0,
                                               minute: timeComponents.minute ?? 0,
                                               second: 0,
                                               of: dateComponents.date ?? Date()) ?? Date()
        print("Printing joinedSelectedDate:\n \(joinedSelectedDate)")
        
        
        // Calculate the time difference between the task time and the current time
        let currentDate = Date()
        let timeDifference = joinedSelectedDate.timeIntervalSince(currentDate)
        
        switch selectedAlertOption {
        case "5 Seconds before":
            if timeDifference >= 5 {
                let newDate = currentDate.addingTimeInterval(timeDifference - 5)
                requestingNotification(date: newDate, content: content)
            }
        case "5 minutes before":
            if timeDifference >= (5 * 60) {
                let newDate = currentDate.addingTimeInterval(timeDifference - (5 * 60))
                requestingNotification(date: newDate, content: content)
            }
        case "10 minutes before":
            if timeDifference >= (10 * 60) {
                let newDate = currentDate.addingTimeInterval(timeDifference - (10 * 60))
                requestingNotification(date: newDate, content: content)
            }
        case "15 minutes before":
            if timeDifference >= (15 * 60) {
                let newDate = currentDate.addingTimeInterval(timeDifference - (10 * 60))
                requestingNotification(date: newDate, content: content)
            }
        case "30 minutes before":
            if timeDifference >= (30 * 60) {
                let newDate = currentDate.addingTimeInterval(timeDifference - 30 * 60)
                requestingNotification(date: newDate, content: content)
            }
        case "1 hour before":
            if timeDifference >= (60 * 60) {
                let newDate = currentDate.addingTimeInterval(timeDifference - (60 * 60))
                requestingNotification(date: newDate, content: content)
            }
        case "2 hours before":
            if timeDifference >= (2 * 60 * 60) {
                let newDate = currentDate.addingTimeInterval(timeDifference - (2 * 60 * 60))
                requestingNotification(date: newDate, content: content)
            }
        default:
            break
        }
    }
    
    /*
     This is function take two arguments (selected date and time) and content we set to the body of the notification.
     */
    static func requestingNotification(date: Date, content: UNMutableNotificationContent) {
        //Getting only (day, month, year, hour, minute, and second from a date.
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        //Setting up the trigger (when the notification should be delivered to the user).
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //Requesting a local notification and passing content and trigger.
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        //Adding requesting into user notification centre
        UNUserNotificationCenter.current().add(request) { error in
            
            //Handling the error
            let errorOccuredRNot = (error != nil) ? "Error setting up notification: \(String(describing: error))" : "Notification scheduled successfully"
            print(errorOccuredRNot)
            
        }
    }
}
