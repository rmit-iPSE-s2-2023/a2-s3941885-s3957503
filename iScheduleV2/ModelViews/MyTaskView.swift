//
//  MyTaskView.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 20/8/2023.
//

import SwiftUI

struct MyTaskView: View {
    var iconName:String = "calendar"
    var iconBackgroundColor:Color = Color(red: 0.24, green: 0.8, blue: 0.98)
    var listName:String = "Assessment"
    var dateForTask:String = "17/08/2023"
    var body: some View {
        HStack{
            HStack(alignment: .center){
               Image(systemName: "\(iconName)")
                .frame(width: 35, height: 35)
                .background(iconBackgroundColor)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .font(.system(size: 20))
                
                
                VStack(alignment: .center){
                    Button(){
                        
                    }label: {
                        Text("\(listName)")
                    }
                }
                .padding([.leading], 3)
                .font(.system(size: 20))
                .fontWeight(.regular)
            }
            .padding([.leading], 15)
            .padding([.trailing], 10)
            HStack{
                VStack{
                    Text("Due Date")
                    Text("\(dateForTask)")
                }
                .fontWeight(.bold)
                Image(systemName: "square").font(.system(size: 25))
            }
            .padding([.leading], 10)
            .padding([.trailing], 15)
            
        }
        .frame(width: 350, height: 60)
        .padding([.bottom, .top], 10)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .padding([.leading], 20)
        .padding([.bottom], 7)
    }
}

struct MyTaskView_Previews: PreviewProvider {
    static var previews: some View {
        MyTaskView()
    }
}
