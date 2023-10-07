import SwiftUI
import CoreData
struct StatisticView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch all "In Progress" Tasks
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "status == %@", "In Progress")
    )
    private var inProgressTasks: FetchedResults<Task>

    // Fetch all "Completed" Tasks
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "status == %@", "Completed")
    )
    private var completedTasks: FetchedResults<Task>

    // Fetch all TaskLists
    @FetchRequest(entity: TaskList.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var allLists: FetchedResults<TaskList>

    struct ListStatistics {
        var color: Color
        var count: Int
    }

    private func fetchNumberOfTasks(for list: TaskList) -> Int {
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

    var listStatistics: [ListStatistics] {
        allLists.map { list in
            ListStatistics(color: colorFromString(list.colorString), count: fetchNumberOfTasks(for: list))
        }
    }

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

    var listPieSlices: [(Double, Color)] {
        let totalTasks = Double(listStatistics.reduce(0, { $0 + $1.count }))
        return listStatistics.map { (Double($0.count) / totalTasks, $0.color) }
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

    var body: some View {
        VStack {
            // Task Categories
            HStack {
                TaskNumView(taskCategory: "In Progress", iconName: "checklist", iconBackgroundColor: Color.blue, numberOfTasks: inProgressTasks.count)
                TaskNumView(taskCategory: "Completed", iconName: "checklist", iconBackgroundColor: Color.orange, numberOfTasks: completedTasks.count)
            }
            .padding([.horizontal], 15)

            Pie(slices: taskStatusPieSlices)
                .frame(width: 150, height: 150)
                .padding()

            Pie(slices: listPieSlices)
                .frame(width: 150, height: 150)
                .padding()

            Spacer()
        }
        .navigationTitle("Statistics")
    }
}
