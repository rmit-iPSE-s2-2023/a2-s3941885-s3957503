//
//  UserRegistrationTest.swift
//  iScheduleTests
//
//  Created by Esmatullah Akhtari on 10/10/2023.
//

import XCTest
@testable import iSchedule

final class UserRegistrationTest: XCTestCase {

    func testIsPasswordValid() {
        let userRegistrationModel = UserRegisterViewModel()
        userRegistrationModel.password = "Password347"
        
        // Printting the password before calling isPasswordValid()
        print("Password before validation: \(userRegistrationModel.password)")
        
        // Checking if the password is a valid password (length >= 8, contains Uppercase, lowercase, and number)
        //If the password is valid, isPasswordValid() function will return true
        let isValidPassword = userRegistrationModel.isPasswordValid()
        
        // Print the result
        print("Is password valid: \(isValidPassword)")
        
        // If the password is valid and isPasswordValid returns true, then the test will pass.
        // Otherwise, the test will fail and show a message that entered password is incorrect.
        XCTAssertTrue(isValidPassword, "Password is NOT valid. Password should Contain (Uppercase, lowercanse and password must be >=8).")
    }

}
