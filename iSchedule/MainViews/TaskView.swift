//Make the design like listview
//Make a button for tasksettings
//When task is pressed it should extend to see description
//Filter sort by dueDate&Time, High med low priority, drag and drop


import SwiftUI
import CoreData

enum Status: String, Identifiable, CaseIterable {
    
    var id: UUID {
        return UUID()
    }
    
    case inProgress = "In Progress"
    case completed = "Completed"
    case all = "All"
}

struct TaskView: View {
    
    @State private var selectedStatus: Status = .inProgress
    @Environment(\.managedObjectContext) private var viewContext
    @State private var refreshID = UUID()

    var selectedTaskList: TaskList
    var fetchRequest: FetchRequest<Task>
    
    init(taskList: TaskList) {
        self.selectedTaskList = taskList
        fetchRequest = FetchRequest<Task>(
            entity: Task.entity(),
            sortDescriptors: [
                NSSortDescriptor(key: "dueDate", ascending: true),
                NSSortDescriptor(key: "dueTime", ascending: true)
            ],
            predicate: NSPredicate(format: "taskList == %@", selectedTaskList)
        )
    }
    
    var fetchedTasks: FetchedResults<Task> {
        fetchRequest.wrappedValue
    }

    private func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = fetchedTasks[index]
            viewContext.delete(task)
        }
        
        do {
            try viewContext.save()
            refreshID = UUID()
        } catch {
            print(error.localizedDescription)
        }
    }

    var body: some View {
        
            VStack {
                Picker("Status", selection: $selectedStatus) {
                    ForEach(Status.allCases) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                List {
                    ForEach(fetchedTasks.filter { task in
                        selectedStatus == .all || task.status == selectedStatus.rawValue
                    }, id: \.self) { task in
                        NavigationLink(destination: TaskSettingsView(task: task).environment(\.managedObjectContext, self.viewContext)) {
                            TaskRow(task: task)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .id(refreshID)
                
            }
            .padding()
            .navigationBarItems(trailing: NavigationLink(
                destination: AddTaskView(selectedList: self.selectedTaskList)
                                .environment(\.managedObjectContext, self.viewContext),
                label: { Text("Add Task") })
            )
            .navigationTitle(selectedTaskList.name ?? "My Tasks")
        }
    
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let newTaskList = TaskList(context: context)
        newTaskList.name = "Preview List"
        return TaskView(taskList: newTaskList)
            .environment(\.managedObjectContext, context)
    }
}

