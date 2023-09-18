//
//  TaskNumView.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 19/8/2023.
//

import SwiftUI

struct TaskNumView: View {
    var taskCategory: String = "In progress"
    var iconName: String = "checklist"
    var iconBackgroundColor: Color = Color(red: 0.24, green: 0.8, blue: 0.98)
    var numberOfTasks: Int = 0
    
    var body: some View {
        HStack {
            Image(systemName: "\(iconName)")
                .frame(width: 35, height: 35)
                .background(iconBackgroundColor)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .font(.system(size: 20))
                
            VStack(alignment: .center) {
                Button(action: {
                    // Your button action here
                }) {
                    Text("\(taskCategory)")
                        .padding([.top])
                        .padding([.bottom], -1)
                }
                Text("\(numberOfTasks)")
                    .fontWeight(.semibold)
            }
            .padding([.leading], 3)
            .font(.system(size: 20))
        }
        .frame(width: 200, height: 100)  
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
}

struct TaskNumView_Previews: PreviewProvider {
    static var previews: some View {
        TaskNumView()
    }
}
