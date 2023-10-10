//
//  UserRegisterViewModel.swift
//  iScheduleV2
//
//  Created by Esmatullah Akhtari on 19/9/2023.
//

import Foundation


class UserRegisterViewModel: ObservableObject {
    let keychain = KeychainManager()
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    

    
    func isPasswordValid() -> Bool {
        // https://regexlib.com/
        // regexlib is used to evaluate password field
        let inputPassword = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9@*#]{8,15})$")
        
        // If password is valid password ( 8 - 15 chars) and also has number (1, 2, 3...) and symbols (#, %, $...) return true
        if inputPassword.evaluate(with: password) {
            print("Password is valid")
            return true
        }
        // If not a valid password return false
        else {
            return false
        }
    }
    
    func matchPassword() -> Bool {
        if isPasswordValid() && password == confirmPassword {
            print("Password matched")
            return true
        }
        return false
    }
    
    func isEmailValid() -> Bool {
        // https://regexlib.com/
        // regexlib is used to evaluate email field
        let inputEmail = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        
        // If email is valid return true
        if inputEmail.evaluate(with: email){
            print("Email is valid")
            return true
        }
        // If email is not valid return false
        return false
    }
    
    func isRegistrationComplete() -> Bool {
        if !isPasswordValid() &&
            !matchPassword() &&
            !isEmailValid(){
            
            print("process not completed")
            return false
        }
        
        return true
    }
    
    func saveCredentials(email: String, password: String){
        if isRegistrationComplete() {
            do {
                try keychain.addCredential(credential: Credentials(username: email,
                                                                   password: password))

                let storedCredentials = try keychain.retrieveCredentials()
                print(storedCredentials)
            } catch {
                print(error)
            }
        }
    }

    
    func validateCredentials(username:String, password:String) ->Bool{
            do {
                let storedCredentials = try keychain.retrieveCredentials()
                print(storedCredentials)
                print(storedCredentials.username)
                print(storedCredentials.password)
                return username == storedCredentials.username && password == storedCredentials.password
            } catch {
                print(error)
                return false
            }
    }
    
}
