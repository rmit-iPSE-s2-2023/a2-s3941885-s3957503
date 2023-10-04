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
        content.title = "iSchedule Reminder"
        content.body = "Upcoming Task:\(taskName)"
        
        
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
                
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        print("Notification scheduled successfully")
                    }
                }
            }
        default:
            break
        }
    }
}
