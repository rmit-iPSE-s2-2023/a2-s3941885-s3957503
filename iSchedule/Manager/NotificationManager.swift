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
    }
}
