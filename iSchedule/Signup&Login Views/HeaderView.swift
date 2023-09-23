//
//  HeaderView.swift
//  ToDoListApp
//
//  Created by Edward on 15/8/2023.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let slogan: String
    let bg1: Color

    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(bg1)
                .frame(height: 350)
                .offset(y:20)
            VStack {
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
                    .font(.system(size: 50))
                Text(slogan)
                    .foregroundColor(Color.white)
                    .bold()
                    .font(.system(size: 18))
            }
            .padding(.top, 50)
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 300)
        .offset(y:-100)
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "iSchedule", slogan: "Plan with Precision, iSchedule Every Mission.", bg1: Color.blue)
    }
}
