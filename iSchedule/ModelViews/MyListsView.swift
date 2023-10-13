import SwiftUI
import CoreData

/**
 A view designed to present a single task list in an overview manner. The list is primarily represented by its name and an associated icon, as well as the number of in-progress tasks contained within.

 ##Usage:
 Initialize the view by providing a task list object. For instance:
 ```swift
 MyListsView(taskList: someTaskListObject)
```
 
 ##Features:
 - Displays the name of the task list.
 - An associated icon with a background color representative of the list's priority or type.
 - Shows the number of tasks within the list that are currently marked as "In Progress".
 - Navigation link to a detailed `TaskView` of the task list.
 - Navigation link to `ListSettingsView` to edit or manage settings related to the task list.
 
 ```swift
 var body: some View {
         HStack {
             VStack {
                 NavigationLink(destination: ListSettingsView(existingList: taskList).environment(\.managedObjectContext, self.viewContext)) {
                     Image(systemName: "\(iconName)")
                         .frame(width: 35, height: 35)
                         .background(iconBackgroundColor)
                         .foregroundColor(.white)
                         .clipShape(Circle())
                         .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                         .font(.system(size: 20))
                 }
                 .padding([.leading], 20)
             }

             VStack(alignment: .center) {
                 NavigationLink(destination: TaskView(taskList: taskList).environment(\.managedObjectContext, viewContext)) {
                     Text(taskList.name ?? "")
                         .padding([.top])
                         .padding([.bottom], -1)
                 }

                 Text("\(numOfTasksInList)")
                     .fontWeight(.bold)
             }
             .font(.system(size: 20))
             .frame(maxWidth: .infinity)
             .padding([.trailing], 40)

             Spacer()
         }
         .frame(width: 400, height: 80)
         .background(Color.white)
         .cornerRadius(10)
         .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
         .padding([.bottom], 7)
         .onAppear {
             self.numOfTasksInList = fetchNumberOfTasks()
         }
     }
 }
 ```
 ##Note:
 This view is dependent on the CoreData entity TaskList and its associated attributes. It also relies on external views, TaskView and ListSettingsView, for navigation purposes. This view was used as the base for `ListRow` and `TaskRow`.
 */
struct MyListsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var numOfTasksInList: Int = 0
    @ObservedObject var taskList: TaskList
    var iconName: String = "gearshape"
    var id: NSManagedObjectID
    
    init(taskList: TaskList) {
        self.taskList = taskList
        self.id = taskList.objectID
    }
    private func fetchNumberOfTasks() -> Int {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        let listPredicate = NSPredicate(format: "taskList == %@", taskList)
        let statusPredicate = NSPredicate(format: "status == %@", "In Progress")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [listPredicate, statusPredicate])
        
        fetchRequest.predicate = compoundPredicate
            
        do {
            let fetchedTasks = try viewContext.fetch(fetchRequest)
            return fetchedTasks.count
        } catch {
            print("Failed to fetch tasks: \(error)")
            return 0
        }
    }

    var iconBackgroundColor: Color {
        if let colorString = taskList.colorString {
            if colorString == "red" {
                return Color.red
            } else if colorString == "orange" {
                return Color.orange
            } else if colorString == "yellow" {
                return Color.yellow
            } else if colorString == "green" {
                return Color.green
            } else if colorString == "blue" {
                return Color.blue
            } else if colorString == "purple" {
                return Color.purple
            } else if colorString == "gray" {
                return Color.gray
            } else if colorString == "pink" {
                return Color.pink
            }
        }
        return Color.gray // default color
    }
    
    var body: some View {
            HStack {
                VStack {
                    NavigationLink(destination: ListSettingsView(existingList: taskList).environment(\.managedObjectContext, self.viewContext)) {
                        Image(systemName: "\(iconName)")
                            .frame(width: 35, height: 35)
                            .background(iconBackgroundColor)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                            .font(.system(size: 20))
                    }
                    .padding([.leading], 20)
                }

                VStack(alignment: .center) {
                    NavigationLink(destination: TaskView(taskList: taskList).environment(\.managedObjectContext, viewContext)) {
                        Text(taskList.name ?? "")
                            .padding([.top])
                            .padding([.bottom], -1)
                    }

                    Text("\(numOfTasksInList)")
                        .fontWeight(.bold)
                }
                .font(.system(size: 20))
                .frame(maxWidth: .infinity)
                .padding([.trailing], 40)

                Spacer()
            }
            .frame(width: 400, height: 80)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            .padding([.bottom], 7)
            .onAppear {
                self.numOfTasksInList = fetchNumberOfTasks()
            }
        }
    }
    

