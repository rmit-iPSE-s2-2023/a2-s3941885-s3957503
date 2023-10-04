import SwiftUI
import CoreData

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var selectedList: TaskList  // Initialized when navigating to this view
    
    @State private var taskName: String = ""
    @State private var description: String = ""
    @State private var selectDate = Date()
    @State private var selectTime = Date()
    @State private var selectedPriority: TaskPriority = .medium
    
    let alertOptionsList = ["None", "5 Seconds before", "5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before"]
    
    var isFormComplete: Bool {
        return !taskName.isEmpty
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
                    .frame(height: 45)
                
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
            addTask()
            presentationMode.wrappedValue.dismiss()
        }, label: { Text("Save") }).disabled(!isFormComplete))
        .navigationTitle(Text("Add Task"))
    }
    
    private func addTask() {
        let newTask = Task(context: viewContext)
        newTask.title = taskName
        newTask.dueDate = selectDate
        newTask.dueTime = selectTime
        newTask.priority = selectedPriority.rawValue
        newTask.taskDescription = description
        newTask.dateCreated = Date()
        newTask.status = "In Progress"
        newTask.taskList = selectedList  // Link the new task to the pre-defined selected TaskList
        
        do {
            try viewContext.save()
            print("Task saved successfully.")
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }
}

// Preview
struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let persistedContainer = CoreDataManager.shared.persistentContainer
        NavigationView {
            AddTaskView(selectedList: TaskList())  // Pass a mock TaskList object here for the preview
                .environment(\.managedObjectContext, persistedContainer.viewContext)
        }
    }
}

