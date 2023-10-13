import SwiftUI
/**
A view designed to represent the number of tasks in a specified category with a descriptive icon.
 
 The view provides:
 - An icon representing the category of the task.
 - The name of the task category (e.g., "In Progress").
 - The total number of tasks in the specified category.
 
 Properties:
 - `taskCategory`: A `String` representing the name of the task category. Default is "In progress".
 - `iconName`: A `String` representing the system name of the icon for the task category. Default is "checklist".
 - `iconBackgroundColor`: A `Color` representing the background color of the icon. Default is a shade of blue.
 - `numberOfTasks`: An `Int` representing the total number of tasks in the specified category. Default is 0.
 
 Usage:
    Initialize the view by providing the necessary properties. For instance:
```swift
TaskNumView(taskCategory: "Completed", iconName: "checkmark", iconBackgroundColor: .green, numberOfTasks: 5)
```
 
```swift
 var body: some View {
     HStack {
         Image(systemName: "\(iconName)")
             .frame(width: 30, height: 30)
             .background(iconBackgroundColor)
             .foregroundColor(.white)
             .clipShape(Circle())
             .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
             .font(.system(size: 20))
             
         VStack(alignment: .center) {
             Button(action: {
                 
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
     .frame(width: 180, height: 70)
     .background(Color.white)
     .cornerRadius(10)
     .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
 }
*/
struct TaskNumView: View {
    var taskCategory: String = "In progress"
    var iconName: String = "checklist"
    var iconBackgroundColor: Color = Color(red: 0.24, green: 0.8, blue: 0.98)
    var numberOfTasks: Int = 0
    
    var body: some View {
        HStack {
            Image(systemName: "\(iconName)")
                .frame(width: 30, height: 30)
                .background(iconBackgroundColor)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .font(.system(size: 20))
                
            VStack(alignment: .center) {
                Button(action: {
                    
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
        .frame(width: 180, height: 70)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
}

