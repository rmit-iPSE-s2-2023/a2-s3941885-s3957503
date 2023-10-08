import SwiftUI
import CoreData

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
    

