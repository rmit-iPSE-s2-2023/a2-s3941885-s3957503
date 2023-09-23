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
                HeaderView(title: "iSchedule", slogan: "Plan with Precision, iSchedule Every Mission.", bg1: Color.blue)
                    .offset(y: 40)
                Form {
                    TextField("Email Address", text: $username)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $password)
                        .textFieldStyle(DefaultTextFieldStyle())
    
                    Button(action: {
                        if UserRegistration.validateCredentials(username: username, password: password) == true {
                            print("Login successfully")
                        }
                        else{
                            print("Username or password incorrect")
                        }
                    }) {
                        Text("Login")
                            .bold()
                        
                    }
                }
                
                VStack {
                    Text("Haven't Created An Account?")
                    NavigationLink("Sign Up", destination: RegisterView())
                }
                .padding(.bottom, 50)
                
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
