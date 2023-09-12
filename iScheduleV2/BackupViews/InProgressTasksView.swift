//
//  InProgressTasksView.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 19/8/2023.
//

import SwiftUI

struct InProgressTasksView: View {
    @State private var searchField:String = ""
    var body: some View {
        ZStack{
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack(alignment: .center){
                    Button (){
                        
                    }label: {
                        Image(systemName: "chevron.backward")
                            .fontWeight(.semibold)
                        Text("Back")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            
                    }
                    Text("Assessment")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .padding([.leading], 58)
                    Button () {
                        
                    }label: {
                        Text("Save")
                    }
                    .fontWeight(.semibold)
                    .padding([.leading], 58)
                    
                }
                .padding(20)
            
                //Search bar
                ZStack {
                    HStack(alignment: .top) {
                        Image(systemName: "magnifyingglass")
                        .padding(1)
                        .foregroundColor(Color(red: 121/255, green: 121/255, blue: 121/255))
                        TextField(
                            "Search...", text: $searchField)
                    }
                    .font(.system(size: 20))
                    .padding(10)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius:15))
                    .padding(15)
                    .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 4)

                }
                //InProgress and Completed buttons
                HStack{
                    TaskNumView(taskCategory: "In Progress",  iconName: "calendar", iconBackgroundColor: Color(red: 0.24, green: 0.8, blue: 0.98),  numberOfTasks: 5)
                        .padding([.leading], 15)
                    
                    TaskNumView(taskCategory: "Completed",  iconName: "checkmark", iconBackgroundColor: Color(red: 0.99, green: 0.75, blue: 0.28),  numberOfTasks: 3)
                        .padding([.leading], 5)

                }
                .padding([.top, .bottom], 8)
                
                Text("My Tasks")
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                    .padding([.top], 5)
                    .padding([.leading], 20)
                    .padding([.bottom], -3)
                
                MyTaskView()
                MyTaskView(iconName: "calendar", iconBackgroundColor:Color(red: 0.99, green: 0.75, blue: 0.28), listName: "Take Notes", dateForTask: "23/08/2023")
                MyTaskView(iconName: "calendar", iconBackgroundColor:Color(red: 0.99, green: 0.75, blue: 0.28), listName: "iOS Activity", dateForTask: "22/08/2023")
                Spacer()
                
            }
            
            
            
        }
    }
}

struct InProgressTasksView_Previews: PreviewProvider {
    static var previews: some View {
        InProgressTasksView()
    }
}
