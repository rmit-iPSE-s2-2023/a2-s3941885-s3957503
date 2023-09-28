import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) private var viewContext
    
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
        HStack {
            NavigationLink(destination: TaskSettingsView(task: task).environment(\.managedObjectContext, self.viewContext)) {
                Image(systemName: "gearshape")
                    .frame(width: 35, height: 35)
                    .background(taskColor)  // Using the computed property for the background color
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
            }
            .frame(maxWidth: .infinity)
            
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
        .padding([.bottom], 7)
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// Your custom Toggle Style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
            .foregroundColor(configuration.isOn ? .blue : .gray)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

