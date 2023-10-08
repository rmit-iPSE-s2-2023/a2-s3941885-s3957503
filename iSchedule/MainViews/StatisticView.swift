import SwiftUI
import CoreData

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
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.blue)
                    
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
                    DonutView(slices: listPieSlices)
                        .frame(width: 120, height: 120)
                        .padding()
                    VStack {
                        let totalTasksCount = Double(filteredTasksForPieChart.values.flatMap { $0 }.count)
                        
                        ForEach(allListsForListPie, id: \.self) { list in
                            if let tasks = filteredTasksForPieChart[list], !tasks.isEmpty {
                                let listPercentage = (Double(tasks.count) / totalTasksCount) * 100
                                
                                HStack {
                                    Circle()
                                        .fill(colorFromString(list.colorString))
                                        .frame(width: 10, height: 10)
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
}

