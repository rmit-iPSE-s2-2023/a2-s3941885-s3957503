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
                    .offset(y: 50)
                HStack {
                    TextField("Email Address", text: $UserRegistration.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    
                    
                    Image(systemName: UserRegistration.isEmailValid() ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(UserRegistration.isEmailValid() ? .green : .red)
                }
                .padding(10)
                .overlay (
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.gray)
                )
                .padding([.top], 10)
                //Password field
                HStack {
                    SecureField("Password", text: $UserRegistration.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    Image(systemName: UserRegistration.isPasswordValid() ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(UserRegistration.isPasswordValid() ? .green : .red)
                }
                .padding(10)
                .overlay (
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.gray)
                )
                .padding([.top], 10)
                
                //Confirm password field
                HStack {
                    SecureField("Confirm Password", text: $UserRegistration.confirmPassword)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    Image(systemName: UserRegistration.matchPassword() ? "checkmark" : "xmark")
                        .fontWeight(.bold)
                        .foregroundColor(UserRegistration.matchPassword() ? .green : .red)
                }
                .padding(10)
                .overlay (
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.gray)
                )
                .padding([.top, .bottom], 10)
                
                
                //Signup button field
                HStack{
                    Button(){
                        if UserRegistration.isRegistrationComplete() == true {
                            UserRegistration.saveCredentials(email: UserRegistration.email, password: UserRegistration.password)
                            
                            print("Registration process completed")
                            
                        }else{
                            print("one of the function does not work")
                        }
                        
                    }label: {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(.blue)
                            .cornerRadius(10)
                            
                        
                    }
                }
                
                Spacer()
            }
            .offset(y: -110)
            .padding(30)
            
            
        }
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
