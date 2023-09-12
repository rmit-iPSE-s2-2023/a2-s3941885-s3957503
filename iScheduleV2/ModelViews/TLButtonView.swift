//
//  TLButtonView.swift
//  ToDoListApp
//
//  Created by Edward on 15/8/2023.
//

import SwiftUI

struct TLButtonView: View {
    let title: String
    let background: Color
    let action: () -> Void
    var body: some View {
        Button(action: {
            // Do something when button is pressed
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background) // Corrected color
                Text("Log In")
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
    }
}

struct TLButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TLButtonView(title: "Value", background: Color.blue) {
            //Action
        }
    }
}
