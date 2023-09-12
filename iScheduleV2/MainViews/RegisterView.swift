//
//  RegisterView.swift
//  ToDoListApp
//
//  Created by Edward on 15/8/2023.
//

import SwiftUI

struct RegisterView: View {
    @State var email = ""
    @State var password = ""
    @State var name = ""
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(title: "Register", slogan: "Start planning with us", bg1: Color.red, bg2: Color.orange, bg3: Color.yellow)
                Form {
                    TextField("Full Name", text: $name)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                    TextField("Email Address", text: $email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    TLButtonView(title: "Register", background: Color.red) {
                        //attempt registration
                    }
                    .padding()
                    
                }
                .offset(y:-40)
                
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
