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
    
    
}
