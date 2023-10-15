import SwiftUI
import CoreData

/**
 `TaskView` represents the primary view for displaying and managing tasks related to a specific `TaskList`. It fetches the `Task` entities from Core Data.
 
 ## Overview:
 - Filter & display tasks based on their status (In Progress, Completed, All).
 - Provides a search bar to search for tasks by their title.
 - Enables sorting of tasks by date and/or priority.
 - Each task is represented with a `TaskRow` that displays its details (title, due date, checkbox, gearshape for settings).
 - Tapping on a `TaskRow` expands it to show the task description.
 - Double tapping on a `TaskRow` allows for quick change of priority rank.
 - Holding on a `TaskRow` provides options to extend its due time.
 - Swipe action on a `TaskRow` (from right to left) deletes the task.
 - "Add Task" button on the navigation bar redirects to ``AddTaskView``.
 
 ## Usage:
 - Use `TaskView(taskList: someTaskList)` to create a view instance where `someTaskList` is an instance of `TaskList`.
 - Embed this view within a navigation view to utilize navigation-based features
 ```swift
 NavigationView {
    TaskView(taskList: someTaskList)
 }
 ```
 
 ## Body:
 The main body of the `TaskView` comprises:
 - A ``SearchBarView`` that allows users to search tasks.
 - A header titled "My Tasks".
 - A sorting menu for users to select their desired sorting method.
 - A picker for filtering tasks based on their status.
 - A list of tasks, each represented with a ``DeleteTaskRowGesture`` view (a custom view that wraps a ``TaskRow`` with additional gesture functionalities).
 
 ```swift
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
 ```
 
 ## Note:
 - The view expects an instance of `TaskList` during initialization.
 - Loads and displays tasks associated with the provided task list.
 - The color of the gearshape circle in a ``TaskRow`` is dependent on the task's priority: green (low), orange (medium), red (high).
 */
struct TaskView: View {
        /// Represents the selected task's status for filtering the task list.
        @State private var selectedStatus: Status = .inProgress
        
        /// The Core Data context used to manage the persisted data.
        @Environment(\.managedObjectContext) private var viewContext
        
        /// A unique ID used to refresh the view when needed, especially after data manipulations.
        @State private var refreshID = UUID()
        
        /// Bindable property for the search bar text, used to filter tasks by title.
        @State private var searchText = ""
        
        /// Represents the selected sort option for tasks.
        @State private var selectedSortOption: SortOption = .dateLowToHigh
        
        /// A boolean that determines whether the options for extending task time are shown or not.
        @State private var showingExtendOptions: Bool = false
        
        /// Represents the currently selected task which the user might choose to extend its time.
        @State private var selectedTaskToExtend: Task?
        
        /// Determines if tasks should be sorted by their date.
        @State private var sortByDate: Bool = true
        
        /// Determines if tasks should be sorted by their priority.
        @State private var sortByPriority: Bool = false
        
        /// The specific `TaskList` instance that the tasks are related to.
        var selectedTaskList: TaskList
        
        /// The fetch request for tasks related to the provided `TaskList`.
        var fetchRequest: FetchRequest<Task>
        
        /// A dictionary to hold time intervals for the possible extend options for a task's due time.
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
                if taskPriorityOrder(task: task1) == taskPriorityOrder(task: task2) {
                    return task1.dueDate! < task2.dueDate!
                }
                return taskPriorityOrder(task: task1) > taskPriorityOrder(task: task2)
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
struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let newTaskList = TaskList(context: context)
        newTaskList.name = "Preview List"
        return TaskView(taskList: newTaskList)
            .environment(\.managedObjectContext, context)
    }
}
