//
//  LoginView.swift
//  Login&SignUp
//
//  Created by Esmatullah Akhtari on 19/9/2023.
//


import SwiftUI

struct LoginView: View {
    @ObservedObject var UserRegistration = UserRegisterViewModel()
    @State var username = ""
    @State var password = ""
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(title: "iSchedule", slogan: "Plan with Precision, iSchedule Every Mission.", bg1: Color.blue, bg2: Color.purple, bg3: Color.pink)
                    .offset(y: -20)
                Spacer()
                
                VStack {
                    // Email Address field
                    HStack {
                        TextField("Email Address", text: $username)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.gray)
                    )
                    .padding([.top], 10)
                    
                    // Password field
                    HStack {
                        SecureField("Password", text: $password)
                            .textFieldStyle(DefaultTextFieldStyle())
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 2)
                            .foregroundColor(.gray)
                    )
                    .padding([.top], 10)
                    
                    // Login button
                    Button(action: {
                        if UserRegistration.validateCredentials(username: username, password: password) == true {
                            print("Login successfully")
                        }
                        else{
                            print("Username or password incorrect")
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding([.top, .bottom], 10)
                }
                .offset(y:-150)
                
                Spacer()
                
                VStack {
                    Text("Haven't Created An Account?")
                    NavigationLink("Sign Up", destination: RegisterView())
                }
                .padding(.bottom)
            }
            .padding(30)
            
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
