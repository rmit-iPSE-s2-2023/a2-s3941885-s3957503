import SwiftUI
/**
A view designed to present a single task in a to-do list. It provides functionalities such as editing task details, viewing task description, and toggling task completion.

 ##Usage:
 Initialize the view by providing a task object. For instance:
 ```swift
 TaskRow(task: someTaskObject)
 ```
 
 ##Features:
 - Represents the task's title and due date-time.
 - Interactive toggle to mark the task as completed or in-progress.
 - Double-tap feature to change the priority of the task.
 - Editable due date-time through a long-press gesture.
 - Expandable task description on a single tap.
 
 ##Properties:
 - `task`: An `ObservedObject` of type `Task` representing the task to display.
 - `viewContext`: The managed object context to perform CoreData operations.
 - `isExpanded`: A `State` boolean variable for toggling task description view expansion.
 - `showingDateEditor`: A `State` boolean variable for toggling the due date-time popover editor.
 
 Note:
 This view is dependent on the CoreData entity Task and its related attributes. It also relies on an external view, TaskSettingsView, to manage task settings.
```swift
 var body: some View {
     VStack(spacing: 0) {
         HStack {
             NavigationLink(destination: TaskSettingsView(task: task).environment(\.managedObjectContext, self.viewContext)) {
                 Image(systemName: "gearshape")
                     .frame(width: 35, height: 35)
                     .background(taskColor)
                     .foregroundColor(.white)
                     .clipShape(Circle())
                     .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                     .font(.system(size: 20))
                     .padding([.leading], 20)
             }.buttonStyle(PlainButtonStyle())
             
             VStack(alignment: .leading) {
                 Text(task.title ?? "")
                     .font(.headline)
                 Text("\(formatter.string(from: task.dueDate ?? Date())), \(timeFormatter.string(from: task.dueTime ?? Date()))")
                     .font(.subheadline)
                     .foregroundColor(.gray)
                     .onLongPressGesture {
                         self.showingDateEditor.toggle()
                     }
                     .popover(isPresented: $showingDateEditor, attachmentAnchor: .point(.trailing), arrowEdge: .trailing) {
                         VStack {
                             DatePicker(
                                 "Edit Date",
                                 selection: Binding<Date>(
                                     get: { task.dueDate ?? Date() },
                                     set: { newValue in task.dueDate = newValue }
                                 ),
                                 displayedComponents: [.date]
                             )
                             DatePicker(
                                 "Edit Time",
                                 selection: Binding<Date>(
                                     get: { task.dueTime ?? Date() },
                                     set: { newValue in task.dueTime = newValue }
                                 ),
                                 displayedComponents: [.hourAndMinute]
                             )

                             Button("Done") {
                                 self.showingDateEditor.toggle()
                                 saveContext()
                             }
                         }
                         .padding()
                     }
             }
             .frame(maxWidth: .infinity)
             // Checkbox, if the box is not ticked then in progress, if ticked then it's completed
             Toggle("", isOn: Binding(
                 get: { task.status == "Completed" },
                 set: { newValue in
                     task.status = newValue ? "Completed" : "In Progress"
                     saveContext()
                 }))
             .toggleStyle(CheckboxToggleStyle())
             .padding([.trailing], 20)
         }
         .frame(height: 80)
         .background(Color.white)
         .cornerRadius(10)
         .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
         .padding([.bottom], isExpanded ? 0 : 7)
         .onTapGesture(count: 2) {
            // This function changes the task's priority when double-tapped
             changePriority()
         }
         .onTapGesture {
             withAnimation {
                // Shows task's description by expanding a small bar at the bottom
                 isExpanded.toggle()
             }
         }
     }
     .padding([.bottom], 7)
 }
*/
struct TaskRow: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isExpanded: Bool = false  // State for expansion
    @State private var showingDateEditor = false // State for date editor popover

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy"
        return formatter
    }()
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    var taskColor: Color {
        switch task.priority {
        case TaskPriority.high.rawValue:
            return Color.red
        case TaskPriority.medium.rawValue:
            return Color.orange
        case TaskPriority.low.rawValue:
            return Color.green
        default:
            return Color.blue
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                NavigationLink(destination: TaskSettingsView(task: task).environment(\.managedObjectContext, self.viewContext)) {
                    Image(systemName: "gearshape")
                        .frame(width: 35, height: 35)
                        .background(taskColor)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        .font(.system(size: 20))
                        .padding([.leading], 20)
                }.buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading) {
                    Text(task.title ?? "")
                        .font(.headline)
                    Text("\(formatter.string(from: task.dueDate ?? Date())), \(timeFormatter.string(from: task.dueTime ?? Date()))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .onLongPressGesture {
                            self.showingDateEditor.toggle()
                        }
                        .popover(isPresented: $showingDateEditor, attachmentAnchor: .point(.trailing), arrowEdge: .trailing) {
                            VStack {
                                DatePicker(
                                    "Edit Date",
                                    selection: Binding<Date>(
                                        get: { task.dueDate ?? Date() },
                                        set: { newValue in task.dueDate = newValue }
                                    ),
                                    displayedComponents: [.date]
                                )
                                DatePicker(
                                    "Edit Time",
                                    selection: Binding<Date>(
                                        get: { task.dueTime ?? Date() },
                                        set: { newValue in task.dueTime = newValue }
                                    ),
                                    displayedComponents: [.hourAndMinute]
                                )

                                Button("Done") {
                                    self.showingDateEditor.toggle()
                                    saveContext()
                                }
                            }
                            .padding()
                        }
                }
                .frame(maxWidth: .infinity)
                // Checkbox, if the box is not ticked then in progress, if ticked then it's completed
                Toggle("", isOn: Binding(
                    get: { task.status == "Completed" },
                    set: { newValue in
                        task.status = newValue ? "Completed" : "In Progress"
                        saveContext()
                    }))
                .toggleStyle(CheckboxToggleStyle())
                .padding([.trailing], 20)
            }
            .frame(height: 80)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            .padding([.bottom], isExpanded ? 0 : 7)
            .onTapGesture(count: 2) {
                changePriority()
            }
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            //Single Tap Gesture
            if isExpanded {
                Text(task.taskDescription?.isEmpty ?? true ? "No description given" : task.taskDescription ?? "")
                    .italic()
                    .opacity(task.taskDescription?.isEmpty ?? true ? 0.5 : 1.0)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            }
        }
        .padding([.bottom], 7)
    }
    
    // This function changes the task's priority when double-tapped
    func changePriority() {
        switch task.priority {
        case TaskPriority.low.rawValue:
            task.priority = TaskPriority.medium.rawValue
        case TaskPriority.medium.rawValue:
            task.priority = TaskPriority.high.rawValue
        case TaskPriority.high.rawValue:
            task.priority = TaskPriority.low.rawValue
        default:
            break
        }
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}


