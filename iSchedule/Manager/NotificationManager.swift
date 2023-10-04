//
//  NotificationManager.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 4/10/2023.
//

import Foundation
import UserNotifications

class NotficationManager{
    
    static func sheduleAlert(taskName: String, selectedDate: Date, selectedTime: Date, selectedAlertOption: String){
        
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
