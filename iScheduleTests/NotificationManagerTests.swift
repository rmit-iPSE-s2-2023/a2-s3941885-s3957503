//
//  NotificationMangerTests.swift
//  iScheduleTests
//
//  Created by Esmatullah Akhtari on 9/10/2023.
//

import XCTest
@testable import iSchedule

final class NotificationMangerTests: XCTestCase {
    
    //Unit Test 08
    func testScheduleAlert() {
        //Setting up data for notification content.
        let taskName = "Testing ScheduleAlert function"
        let selectedDate = Date()
        let selectedTime = Date()
        let selectedAlertOption = "5 Seconds before"
        
        
        // Calling the scheduleAlert method to test scheduling notification.
        NotficationManager.scheduleAlert(taskName: taskName, selectedDate: selectedDate, selectedTime: selectedTime, selectedAlertOption: selectedAlertOption)
        
        // Extract the notification request
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            guard let notificationRequest = requests.first else {
                // If no notification request is found, test will fail.
                XCTFail("No notification request found")
                return
            }
            // Checking properties of the notification request such as content title.
            XCTAssertEqual(notificationRequest.content.title, taskName)
            
            // Checking the identifier property of the requested notification.
            XCTAssertEqual(notificationRequest.identifier, selectedAlertOption)
            
        }
        
    }
    

}
