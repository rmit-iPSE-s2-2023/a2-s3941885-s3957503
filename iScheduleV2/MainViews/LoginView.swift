//
//  LoginView.swift
//  ToDoListApp
//
//  Created by Edward on 15/8/2023.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            if isLoggedIn {
                MainTabView()
                    .environmentObject(ListViewModel())
                    .environmentObject(TaskViewModel())
            } else {
                VStack {
                    HeaderView(title: "iSchedule", slogan: "Plan with Precision, iSchedule Every Mission.", bg1: Color.blue, bg2: Color.purple, bg3: Color.pink)
                        .offset(y: 40)
                    Form {
                        TextField("Email Address", text: $email)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(DefaultTextFieldStyle())
                        
                        Button(action: {
                            isLoggedIn = true // Set to true to navigate to MainTabView
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.blue)
                                Text("Log In")
                                    .foregroundColor(Color.white)
                                    .bold()
                            }
                        }
                        .padding()
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
