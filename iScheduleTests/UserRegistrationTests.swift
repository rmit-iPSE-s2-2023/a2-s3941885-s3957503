//
//  UserRegistrationTest.swift
//  iScheduleTests
//
//  Created by Esmatullah Akhtari on 10/10/2023.
//

import XCTest
@testable import iSchedule

final class UserRegistrationTest: XCTestCase {
    
    //Unit Test 01
    func testIsPasswordValid() {
        //Creating instance of UserRegistrationViewModel
        let userRegistrationModel = UserRegisterViewModel()
        
        //Assigning a password to password field
        userRegistrationModel.password = "Password347"
        
        // Printting the password before calling isPasswordValid()
        print("Password before validation: \(userRegistrationModel.password)")
        
        // Checking if the password is a valid password (length >= 8, contains Uppercase, lowercase, and number)
        //If the password is valid, isPasswordValid() function will return true
        let isValidPassword = userRegistrationModel.isPasswordValid()
        
        // Print the result of isPasswordValid is (True OR False)
        print("Is password valid: \(isValidPassword)")
        
        // If the password is valid and isPasswordValid returns true, then the test will pass.
        // Otherwise, the test will fail and show a message that entered password is incorrect.
        XCTAssertTrue(isValidPassword, "Password is NOT valid. Password should Contain (Uppercase, lowercanse and password must be >=8).")
    }
    
    //Unit Test 02
    
    func testInvalidPassword(){
        //Creating instance of UserRegistrationViewModel
        let userRegistrationModel = UserRegisterViewModel()
        
        //Assigning a password to password field
        userRegistrationModel.password = "valid"
        
        
        // Checking if the password is a valid password (length >= 8, contains Uppercase, lowercase, and number)
        //If the password is valid, isPasswordValid() function will return true
        let isValidPassword = userRegistrationModel.isPasswordValid()
        
        // Print the result of isPasswordValid is (True OR False)
        //The result should be False because password is not valid.
        print("Is password valid: \(isValidPassword)")
        
        // If the password is valid and isPasswordValid returns true, then the test will pass.
        // Otherwise, the test will fail and show a message that entered password is incorrect.
        XCTAssertFalse(isValidPassword, "Password is valid. Password Contain (Uppercase, lowercanse and password >=8).")
    }
    
    //Unit Test 03
    
    func testMatchPasswords(){
        //Creating instance of UserRegistrationViewModel
        let userRegistrationModel = UserRegisterViewModel()
        
        //Assigning a password to password and confirmPassword fields
        userRegistrationModel.password = "Password348"
        userRegistrationModel.confirmPassword = "Password348"
        
        
        // If password and confirmPassword fields match then it will return true.
        let passwordsMatch = userRegistrationModel.matchPassword()
        
        // If password and confirmPassword fields match then the matchPassword() function will return true and the test will pass.
        XCTAssertTrue(passwordsMatch, "Password and confirm password fields are NOT matching")
    }
    
    
    //Unit Test 04
    
    func testIsEmailValid(){
        //Creating instance of UserRegistrationViewModel
        let userRegistrationModel = UserRegisterViewModel()
        //Assigning a demo email to email field in order to check email validation function.
        userRegistrationModel.email = "iossoftware@gmail.com"
        
        // Checking if the entered email is a valid email (gmail...)
        //If the email is valid, isEmailValid() function will return true
        let emailValidation = userRegistrationModel.isEmailValid()
        
        // Print the result of isEmailValid is (True OR False)
        //The result should be True, because it is a valid email.
        print("Is email valid: \(emailValidation)")
        
        // If the email is valid and isEmailValid returns true, then the test will pass.
        // Otherwise, the test will fail and show a message that entered email is incorrect.
        XCTAssertTrue(emailValidation, "Provided email is NOT valid.")
    }
    
    //Unit Test 05
    
    func testInValidEmail(){
        //Creating instance of UserRegistrationViewModel
        let userRegistrationModel = UserRegisterViewModel()
        //Assigning a string to email field in order to check email validation function.
        userRegistrationModel.email = "iossoftware"
        
        
        // Checking if the entered email is a valid email (gmail...)
        //If the email is valid, isEmailValid() function will return true
        let isValid = userRegistrationModel.isEmailValid()
        
        // Print the result of isEmailValid is (True OR False)
        //The result should be false, because the input is just a string and it is not a valid email.
        print("Is email valid: \(isValid)")
        
        // If the email is not valid and isEmailValid returns false, then the test will pass.
        // Otherwise, the test will fail and show a message that entered email is correct.
        XCTAssertFalse(isValid, "Provided email is valid.")
    }
    
    // Unit Test 06
    
    func testRetrievingCredentials() {
        
        //Creating an instance of UserRegistrationViewModel
        let userRegistrationModel = UserRegisterViewModel()
        //Creating an instance of KeyChainManager to save and retrive credentials.
        let keychainManager = KeychainManager()
        
        //Saving Credentials.
        userRegistrationModel.saveCredentials(email: "iossoftware@gmail.com", password: "Password347")
        
        
        //Retrieving email.
        let email = "iossoftware@gmail.com"
        //Retrieving password.
        let password = "Password347"

        do {
            //Calling KeychainManager retrieveCredential function to retrieve email and password.
            let retrievedCredentials = try keychainManager.retrieveCredentials()
            
            //If email and password are correct, the test will pass.
            //If email/password does not exist or email/password incorrect, the test will fail and show an error.
            XCTAssertEqual(retrievedCredentials.username, email, "Email does not exist, please enter a valid email.")
            XCTAssertEqual(retrievedCredentials.password, password, "Incorrect password, please try again.")
        } catch {
            //Getting errors.
            XCTFail("Error in retrieving credentials: \(error)")
        }
    }
    
    // Unit Test 07
    
    func testRetrievingInvalidCredentials() {
        
        //Creating an instance of UserRegistrationViewModel
        let userRegistrationModel = UserRegisterViewModel()
        //Creating an instance of KeyChainManager to save and retrive credentials.
        let keychainManager = KeychainManager()
        
        
        //Saving Credentials.
        userRegistrationModel.saveCredentials(email: "iossoftware@gmail.com", password: "Password347")
        
        
        //assigning an invalid email to email field for retriving
        let email = "iossoftware1@gmail.com"
        //Giving an invalid password for retrieving.
        let password = "Password"
        
        do {
            //Calling KeychainManager retrieveCredential function.
            let retrievedCredentials = try keychainManager.retrieveCredentials()
            
            //If email and password are correct, the test will pass.
            //If email/password does not exist or email and password are incorrect, the test will fail and show an error.
            //Since email and password both are incorrect, the test will fail and show errors.
            XCTAssertNotEqual(retrievedCredentials.username, email, "Email is Valid.")
            XCTAssertNotEqual(retrievedCredentials.password, password, "Password is correct.")
        } catch {
            //If the test fails, getting errors.
            XCTFail("Error in retrieving credentials: \(error)")
        }
    }
    
    
    // Unit Test 09
    func testIsRegistrationCompleted(){
        //Creating an instance of UserRegistrationViewModel
        let userRegistrationModel = UserRegisterViewModel()
        //Assigning an email to email field
        userRegistrationModel.email = "iossoftware@gmail.com"
        //Assigning password and confirm password to UserRegistration Model
        userRegistrationModel.password = "Password34"
        userRegistrationModel.confirmPassword = "Password34"
        
        //Calling isRegistrationComplete function.
        let hasProcessCompleted = userRegistrationModel.isRegistrationComplete()
        
        // Print the result of isRegistrationComplete() (True OR False)
        print("Process Status: \(hasProcessCompleted)")
        
        // Checking if email, password, and confirmPassword are valid and
        // isPassword(), matchPassword(), and isEmailValid function return true, the test will pass.
        //Otherwise, isRegistrationComplete method will return false, and test will fail.
        XCTAssertTrue(hasProcessCompleted, "Incorrect username OR password, please try again.")
    }
    
    // Unit Test 10
    
    func testRegistrationNOTCompleted(){
        //Creating an instance of UserRegistrationViewModel
        let userRegistrationModel = UserRegisterViewModel()
        //Assigning an email to email field
        userRegistrationModel.email = "iossoftware"
        //Assigning password and confirm password to UserRegistration Model
        userRegistrationModel.password = "Pass"
        userRegistrationModel.confirmPassword = "Pass"
        
        //Calling isRegistrationComplete function.
        let hasProcessCompleted = userRegistrationModel.isRegistrationComplete()
        
        // Print the result of isRegistrationComplete() (True OR False)
        print("Process Status: \(hasProcessCompleted)")
        
        // Checking if email, password, and confirmPassword are valid and
        // isPassword(), matchPassword(), and isEmailValid function return true, the test will pass.
        //Otherwise, isRegistrationComplete method will return false, and test will fail.
        XCTAssertFalse(hasProcessCompleted, "correct username OR password, please try again.")
    }
    
    
    
    
}
