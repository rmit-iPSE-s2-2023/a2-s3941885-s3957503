import SwiftUI

struct TaskSettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var task: Task
    
    @State private var taskName: String
    @State private var description: String
    @State private var selectDate = Date()
    @State private var selectTime = Date()
    @State private var selectedPriority: TaskPriority
    
    init(task: Task) {
        self.task = task
        self._taskName = State(initialValue: task.title ?? "")
        self._description = State(initialValue: task.taskDescription ?? "")
        self._selectDate = State(initialValue: task.dueDate ?? Date())
        self._selectTime = State(initialValue: task.dueTime ?? Date())
        self._selectedPriority = State(initialValue: TaskPriority(rawValue: task.priority ?? "Medium") ?? .medium)
    }
    
    var combinedDateTime: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: selectTime)
        
        return calendar.date(bySettingHour: timeComponents.hour ?? 0,
                             minute: timeComponents.minute ?? 0,
                             second: 0,
                             of: dateComponents.date ?? Date()) ?? Date()
    }
    
    var body: some View {
        Form {
            Section("Task Details") {
                TextField("Title", text: $taskName)
                
                DatePicker(
                    "Date",
                    selection: $selectDate,
                    displayedComponents: [.date]
                )
                DatePicker(
                    "Time",
                    selection: $selectTime,
                    displayedComponents: [.hourAndMinute]
                )
                
                Picker(selection: $selectedPriority, label: Text("Priority")) {
                    ForEach(TaskPriority.allCases, id: \.self) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            
            Section("Description") {
                TextEditor(text: $description)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 1)
                    .frame(height: 100)
            }
        }
        .navigationBarItems(trailing: Button(action: {
            // Update task details
            task.title = taskName
            task.taskDescription = description
            task.dueDate = selectDate
            task.dueTime = selectTime
            task.priority = selectedPriority.rawValue
            
            // Save changes
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
            
            presentationMode.wrappedValue.dismiss()
        }, label: { Text("Save") }))
        .navigationTitle(Text("Edit Task"))
    }
}

