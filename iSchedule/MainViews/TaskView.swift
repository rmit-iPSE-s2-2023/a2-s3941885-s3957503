import SwiftUI
import CoreData


enum TaskPriority: String, CaseIterable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}

enum Status: String, Identifiable, CaseIterable {
    var id: UUID {
        return UUID()
    }
    
    case inProgress = "In Progress"
    case completed = "Completed"
    case all = "All"
}

enum SortOption: String, CaseIterable {
    case dateHighToLow = "Date: High to Low"
    case dateLowToHigh = "Date: Low to High"
    case priorityHighToLow = "Priority: High to Low"
    case priorityLowToHigh = "Priority: Low to High"
    case dateAndPriorityHighToLow = "Date & Priority: High to Low"
    case dateAndPriorityLowToHigh = "Date & Priority: Low to High"
}


struct TaskView: View {
    @State private var selectedStatus: Status = .inProgress
    @Environment(\.managedObjectContext) private var viewContext
    @State private var refreshID = UUID()
    @State private var searchText = ""
    @State private var selectedSortOption: SortOption = .dateLowToHigh
    @State private var showingExtendOptions: Bool = false
    @State private var selectedTaskToExtend: Task?
    @State private var sortByDate: Bool = true
    @State private var sortByPriority: Bool = false
    
    var selectedTaskList: TaskList
    var fetchRequest: FetchRequest<Task>
    
    let extendOptions: [String: TimeInterval] = [
        "+30 min": 30*60,
        "+1hr": 1*3600,
        "+2hr": 2*3600,
        "+3hr": 3*3600,
        "+6hr": 6*3600,
        "+12hr": 12*3600,
        "+24hr": 24*3600,
        "+48hr": 48*3600
    ]
    
    init(taskList: TaskList) {
        self.selectedTaskList = taskList
        fetchRequest = FetchRequest<Task>(
            entity: Task.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "taskList == %@", selectedTaskList)
        )
    }
    
    var fetchedTasks: FetchedResults<Task> {
        fetchRequest.wrappedValue
    }
    
    var sortedTasks: [Task] {
        fetchedTasks.sorted { task1, task2 in
            if sortByDate && sortByPriority {
                if task1.dueDate! == task2.dueDate! {
                    return taskPriorityOrder(task: task1) > taskPriorityOrder(task: task2)
                }
                return task1.dueDate! < task2.dueDate!
            } else if sortByDate {
                return task1.dueDate! < task2.dueDate!
            } else if sortByPriority {
                return taskPriorityOrder(task: task1) > taskPriorityOrder(task: task2)
            }
            return true
        }
    }

    
    
    
    func taskPriorityOrder(task: Task) -> Int {
        switch task.priority {
        case TaskPriority.high.rawValue:
            return 3
        case TaskPriority.medium.rawValue:
            return 2
        case TaskPriority.low.rawValue:
            return 1
        default:
            return 0
        }
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
    
    func extendTime(for task: Task, by interval: TimeInterval) {
        guard let currentDueDate = task.dueDate else { return }
        task.dueDate = currentDueDate.addingTimeInterval(interval)
        do {
            try viewContext.save()
            refreshID = UUID()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(text: $searchText)
                .padding([.horizontal])
                .padding(.bottom, 10)
            
            ScrollView {
                VStack(spacing: 15) {
                    HStack {
                        Text("My Tasks")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        Menu {
                            HStack {
                                ButtonToggleView(title: "Date", isOn: $sortByDate)
                                        .padding(.trailing, 10)
                                    
                                ButtonToggleView(title: "Priority", isOn: $sortByPriority)
                            }
                            .padding(.trailing)

                        } label: {
                            Label("Sort by", systemImage: "arrow.up.arrow.down.circle")
                        }

                    }
                    .padding(.trailing)
                    
                    Picker("Status", selection: $selectedStatus) {
                        ForEach(Status.allCases) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom, 10)
                    
                    ForEach(sortedTasks.filter { task in
                        (selectedStatus == .all || task.status == selectedStatus.rawValue) &&
                        (searchText.isEmpty || task.title!.contains(searchText))
                    }, id: \.self) { task in
                        DeleteTaskRowGesture(task: task) {
                            deleteTask(at: [fetchedTasks.firstIndex(of: task)!])
                        }
                        .environment(\.managedObjectContext, self.viewContext)
                    }
                }
                .padding()
            }
        }
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
