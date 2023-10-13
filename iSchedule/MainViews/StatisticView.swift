import SwiftUI
import CoreData
/**
 `StatisticView` statistics on all lists tasks using pie charts, as well as having a view that fetches motivational quotes from an API.
 
 ## Overview:
 - Pie Chart: Represents the number of tasks in a selected list, categorized by status ("In Progress" or "Completed"). It's associated with two textual statistics, which respectively show the number of tasks "In Progress" and "Completed".
 - Donut Chart: Represents the distribution of tasks across various lists, provided with an accompanying textual breakdown that includes each list's name, the number of tasks within, and the percentage of total tasks it represents.
 - Filters to select a specific list or filter by task status.
 - Detailed breakdown of tasks in different lists with associated percentages.

 ## Usage:
 To integrate the `StatisticView` into a SwiftUI view, use:
 ```swift
 StatisticView().environment(\.managedObjectContext, context)
 ```
 
 ## Body:
 The body of the StatisticView contains two main sections:
 1. Task Status Section: This section contains:
 - A title indicating it represents the number of tasks in the selected list.
 - A dropdown menu allowing the user to filter tasks by list.
 - A visual representation of the number of tasks "In Progress" and "Completed".
 - A pie chart that visually represents the distribution of tasks by status.
 - The percentage of tasks that are completed.
 2. Total Task Amount Section: This section contains:
 - A title indicating it represents the total number of tasks.
 - A segmented control allowing the user to filter tasks by their status.
 - A donut chart that visually represents the distribution of tasks across various lists.
 - A breakdown of each list, the number of tasks in that list, and the associated percentage with respect to the total task count.
 ```swift
 var body: some View {
     VStack {
         Text("Amount of tasks in the selected list")
             .font(.title2)
             .fontWeight(.semibold)
             .foregroundColor(Color.primary)
             .frame(maxWidth: .infinity, alignment: .leading)
             .padding(.leading)
         VStack {
             //First Piechart
             HStack(alignment: .center, spacing: 8) {
                 Image(systemName: "line.horizontal.3.decrease.circle")
                     .resizable()
                     .scaledToFit()
                     .frame(width: 18, height: 18)
                     .foregroundColor(.blue)
                 //Filter to know the amount of tasks in a specific list
                 Picker("Filter", selection: $selectedFilter) {
                     Text("All").tag(nil as TaskList?)
                     ForEach(allLists, id: \.self) { list in
                         Text(list.name ?? "").tag(list as TaskList?)
                     }
                 }
                 .pickerStyle(MenuPickerStyle())
                 .frame(width: 200, height: 30)
                 .font(Font.system(size: 14, weight: .medium))
                 .padding(.vertical, 4)
                 .background(Color.white)
                 .cornerRadius(6)
                 .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
             }
             
             HStack {
                 VStack {
                     //Displays for the amount of tasks in inprogress and completed
                     TaskNumView(taskCategory: "In Progress", iconName: "checklist", iconBackgroundColor: Color.blue, numberOfTasks: inProgressTasks.count)
                     TaskNumView(taskCategory: "Completed", iconName: "checklist", iconBackgroundColor: Color.orange, numberOfTasks: completedTasks.count)
                 }
                 
                 ZStack {
                     PieView(slices: taskStatusPieSlices)
                         .frame(width: 150, height: 150)
                         .padding()
                     let completedPercentage = (inProgressTasks.count + completedTasks.count) == 0 ? 0 : Double(completedTasks.count) / Double(inProgressTasks.count + completedTasks.count)
                     Text("\(Int(completedPercentage * 100))% Completed")
                         .font(Font.system(size: 18))
                         .foregroundColor(.white)
                 }
             }
         }
         .padding([.horizontal], 15)
         .padding(.bottom, 16)
         .background(Color(.secondarySystemBackground))
         .cornerRadius(10)
         .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
         
         Text("Total amount of tasks")
             .font(.title2)
             .fontWeight(.semibold)
             .foregroundColor(Color.primary)
             .frame(maxWidth: .infinity, alignment: .leading)
             .padding(.leading)
         VStack {
             Picker("Task Status", selection: $taskStatusFilter) {
                 Text("In Progress").tag("In Progress")
                 Text("Completed").tag("Completed")
             }
             .pickerStyle(SegmentedPickerStyle())
             HStack {
                 //Second Piechart
                 DonutView(slices: listPieSlices)
                     .frame(width: 120, height: 120)
                     .padding()
                 VStack {
                     let totalTasksCount = Double(filteredTasksForPieChart.values.flatMap { $0 }.count)
                     //Fetch all lists and the tasks within it
                     ForEach(allListsForListPie, id: \.self) { list in
                         if let tasks = filteredTasksForPieChart[list], !tasks.isEmpty {
                             let listPercentage = (Double(tasks.count) / totalTasksCount) * 100
                             
                             HStack {
                                 Circle()
                                     .fill(colorFromString(list.colorString))
                                     .frame(width: 10, height: 10)
                                 //Display the amount of the tasks in a list and how much percentage the list weighs in the total amount
                                 Text("\(list.name ?? ""): \(tasks.count) (\(String(format: "%.1f", listPercentage))%)")
                                     .font(.footnote)
                             }
                         }
                     }
                     
                 }
             }
         }
         .padding([.horizontal], 15)
         .padding(.bottom, 16)
         .background(Color(.secondarySystemBackground))
         .cornerRadius(10)
         .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
         Spacer()
     }
     .navigationTitle("Statistics")
 }
 ```
 
 ## Notes:
 - The statistics and charts are generated based on the fetched data from the CoreData context.
 - The pie and donut charts are color-coded based on the status of tasks or the colors associated with the task lists.
 
 */
struct StatisticView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // General state and fetch properties
    @State private var selectedFilter: TaskList? = nil
    @FetchRequest(entity: TaskList.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var allLists: FetchedResults<TaskList>
    
    // MARK: - Task Status Pie Chart
    
    @State private var taskStatusFilter: String = "In Progress"
    
    var inProgressTasks: [Task] {
        fetchTasks(with: "In Progress")
    }
    
    var completedTasks: [Task] {
        fetchTasks(with: "Completed")
    }
    
    var taskStatusPieSlices: [(Double, Color)] {
        let totalTasks = Double(inProgressTasks.count + completedTasks.count)
        let completedPercentage = totalTasks == 0 ? 0 : Double(completedTasks.count) / totalTasks
        let inProgressPercentage = 1 - completedPercentage
        
        return [
            (inProgressPercentage, Color.blue),
            (completedPercentage, Color.orange)
        ]
    }
    
    // MARK: - List Pie Chart
    
    @FetchRequest(entity: TaskList.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var allListsForListPie: FetchedResults<TaskList>
    
    //used for donut as well
    var filteredTasksForPieChart: [TaskList: [Task]] {
        var tasksDictionary: [TaskList: [Task]] = [:]
        for list in allListsForListPie {
            tasksDictionary[list] = fetchTasks(with: taskStatusFilter, for: list)
        }
        return tasksDictionary
    }
    //used for donut as well
    var listPieSlices: [(Double, Color)] {
        let totalTasks = Double(filteredTasksForPieChart.values.flatMap { $0 }.count)
        if totalTasks == 0 { return [] }
        return allListsForListPie.compactMap { list -> (Double, Color)? in
            if let tasks = filteredTasksForPieChart[list], !tasks.isEmpty {
                let listPercentage = Double(tasks.count) / totalTasks
                return (listPercentage, colorFromString(list.colorString))
            }
            return nil
        }
    }
    
    
    struct ListStatistics {
        var color: Color
        var count: Int
    }
    var listStatistics: [ListStatistics] {
        allLists.map { list in
            ListStatistics(color: colorFromString(list.colorString), count: fetchNumberOfTasks(for: list))
        }
    }
    
    // MARK: - Common Functions
    
    func colorFromString(_ colorString: String?) -> Color {
        switch colorString {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "gray": return .gray
        case "pink": return .pink
        default: return .gray
        }
    }
    
    func fetchTasks(with status: String) -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        if let selectedList = selectedFilter {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "status == %@", status),
                NSPredicate(format: "taskList == %@", selectedList)
            ])
        } else {
            fetchRequest.predicate = NSPredicate(format: "status == %@", status)
        }
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks with status \(status): \(error)")
            return []
        }
    }
    
    func fetchTasks(with status: String, for list: TaskList) -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = []
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "status == %@", status),
            NSPredicate(format: "taskList == %@", list)
        ])
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch tasks with status \(status) for list \(list.name ?? "unknown"): \(error)")
            return []
        }
    }
    
    func fetchNumberOfTasks(for list: TaskList) -> Int {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "taskList == %@", list)
        
        do {
            let fetchedTasks = try viewContext.fetch(fetchRequest)
            return fetchedTasks.count
        } catch {
            print("Failed to fetch tasks: \(error)")
            return 0
        }
    }
    
    var body: some View {
        VStack {
            Text("Amount of tasks in the selected list")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            VStack {
                //First Piechart
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.blue)
                    //Filter to know the amount of tasks in a specific list
                    Picker("Filter", selection: $selectedFilter) {
                        Text("All").tag(nil as TaskList?)
                        ForEach(allLists, id: \.self) { list in
                            Text(list.name ?? "").tag(list as TaskList?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 200, height: 30)
                    .font(Font.system(size: 14, weight: .medium))
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .cornerRadius(6)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                
                HStack {
                    VStack {
                        //Displays for the amount of tasks in inprogress and completed
                        TaskNumView(taskCategory: "In Progress", iconName: "checklist", iconBackgroundColor: Color.blue, numberOfTasks: inProgressTasks.count)
                        TaskNumView(taskCategory: "Completed", iconName: "checklist", iconBackgroundColor: Color.orange, numberOfTasks: completedTasks.count)
                    }
                    
                    ZStack {
                        PieView(slices: taskStatusPieSlices)
                            .frame(width: 150, height: 150)
                            .padding()
                        let completedPercentage = (inProgressTasks.count + completedTasks.count) == 0 ? 0 : Double(completedTasks.count) / Double(inProgressTasks.count + completedTasks.count)
                        Text("\(Int(completedPercentage * 100))% Completed")
                            .font(Font.system(size: 18))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding([.horizontal], 15)
            .padding(.bottom, 16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            
            Text("Total amount of tasks")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            VStack {
                Picker("Task Status", selection: $taskStatusFilter) {
                    Text("In Progress").tag("In Progress")
                    Text("Completed").tag("Completed")
                }
                .pickerStyle(SegmentedPickerStyle())
                HStack {
                    //Second Piechart
                    DonutView(slices: listPieSlices)
                        .frame(width: 120, height: 120)
                        .padding()
                    VStack {
                        let totalTasksCount = Double(filteredTasksForPieChart.values.flatMap { $0 }.count)
                        //Fetch all lists and the tasks within it
                        ForEach(allListsForListPie, id: \.self) { list in
                            if let tasks = filteredTasksForPieChart[list], !tasks.isEmpty {
                                let listPercentage = (Double(tasks.count) / totalTasksCount) * 100
                                
                                HStack {
                                    Circle()
                                        .fill(colorFromString(list.colorString))
                                        .frame(width: 10, height: 10)
                                    //Display the amount of the tasks in a list and how much percentage the list weighs in the total amount
                                    Text("\(list.name ?? ""): \(tasks.count) (\(String(format: "%.1f", listPercentage))%)")
                                        .font(.footnote)
                                }
                            }
                        }
                        
                    }
                }
            }
            .padding([.horizontal], 15)
            .padding(.bottom, 16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            
            //Quote should be here
            Spacer()
        }
        .navigationTitle("Statistics")
    }
}

