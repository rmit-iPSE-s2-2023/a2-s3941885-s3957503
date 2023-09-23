//
//  RegisterView.swift
//  Login&SignUp
//
//  Created by Esmatullah Akhtari on 19/9/2023.
//

import SwiftUI

struct RegisterView: View {
        @ObservedObject var UserRegistration = UserRegisterViewModel()
//    @State var name = ""
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(title: "Register", slogan: "Start planning with us", bg1: Color.red, bg2: Color.orange, bg3: Color.yellow)
                Form {
                    TextField("Email Address", text: $UserRegistration.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $UserRegistration.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    SecureField("Confirm Password", text: $UserRegistration.confirmPassword)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                }
                
                    .offset(y:-40)
                Button(){
                    if UserRegistration.isRegistrationComplete() == true {
                        UserRegistration.saveCredentials(email: UserRegistration.email, password: UserRegistration.password)
                        
                        print("Registration process completed")
                        
                    }else{
                        print("one of the function does not work")
                    }
                    
                }label: {
                    Text("Sign Up")
                        .frame(maxWidth: .maximum(200.00, 100.00))
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        .foregroundColor(.white)
                }
                Spacer()
            }
        
        }
       
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
