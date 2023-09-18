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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title ?? "")
            }
            Spacer()
            Text("\(formatter.string(from: task.dueDate ?? Date())), \(timeFormatter.string(from: task.dueTime ?? Date()))")
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Toggle("", isOn: Binding(
                get: { task.status == "Completed" },
                set: { newValue in
                    task.status = newValue ? "Completed" : "In Progress"
                    saveContext()
                }))
            .toggleStyle(CheckboxToggleStyle())
        }
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

