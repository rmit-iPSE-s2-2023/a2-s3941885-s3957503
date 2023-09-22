//
//  UserRegistrationViewModel.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 23/9/2023.
//

import Foundation

class UserRegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    
    func matchPassword() -> Bool {
        if password == confirmPassword {
            return true
        }
        return false
    }
    
    func isPasswordValid() -> Bool {
        // https://regexlib.com/
        // regexlib is used to evaluate password field 
        let inputPassword = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9@*#]{8,15})$")
        
        // If password is valid password ( 8 - 15 chars) and also has number (1, 2, 3...) and symbols (#, %, $...) return true
        if inputPassword.evaluate(with: password) {
            return true
        }
        // If not a valid password return false
        else {
            return false
        }
    }
    
    func isEmailValid() -> Bool {
        // https://regexlib.com/
        // regexlib is used to evaluate email field
        let inputEmail = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        
        // If email is valid return true
        if inputEmail.evaluate(with: email){
            return true
        }
        // If email is not valid return false
        return false
    }
    
    
}
