import SwiftUI
/**
 A view that provides an interface to edit details for a specific task.

 This view allows users to modify various attributes of a `Task`, such as its title, due date, time, priority, and notification options.
 After making changes, the view will save the task's updated details to Core Data. This view can be accessed by clicking on the gearshape symbol on the `TaskView`. To use this view, an instance of `Task` must be provided during initialization. The view will then load the task's current details and provide an interface for modifications.
 
 Usage:
 ```swift
 TaskSettingsView(task: existingTaskEntity)
 ```
 
 Properties:
  - `task`: An `ObservedObject` of type `Task` representing the task entity to be edited.
  - `taskName`: A `State` property that holds the title of the task.
  - `description`: A `State` property that contains the description of the task.
  - `selectDate`: A `State` property representing the due date of the task.
  - `selectTime`: A `State` property indicating the due time for the task.
  - `selectedPriority`: A `State` property representing the priority level of the task. Possible values are `.low`, `.medium`, and `.high`.
  - `selectedAlertOption`: A `State` property indicating the selected notification alert timing option for the task.
  - `alertOptionsList`: A constant list containing various alert timing options.
 
 Notes:
 - Ensure that an instance of Task is available and passed as an argument when initializing TaskSettingsView.
 - The combinedDateTime computed property combines the selected date and time into a single Date object.
 - The TaskPriority enumeration should define cases for .low, .medium, and .high for priority selection.
 - Ensure the Core Data entity for Task contains properties for title, taskDescription, dueDate, dueTime, priority, and alertOption.
 - The viewContext from the @Environment property wrapper is used to save changes to Core Data.
 
 ```swift
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
             // User can pick between: Low, Medium, High (Medium by default)
             Picker(selection: $selectedPriority, label: Text("Priority")) {
                 ForEach(TaskPriority.allCases, id: \.self) { priority in
                     Text(priority.rawValue).tag(priority)
                 }
             }
             .pickerStyle(MenuPickerStyle())
             .frame(maxWidth: .infinity, alignment: .leading)
             
         }
         Section(header: Text("Notification Options")) {
             Picker("Set Alert", selection: $selectedAlertOption) {
                 ForEach(alertOptionsList, id: \.self) { option in
                     Text(option)
                 }
             }
             .pickerStyle(.menu)
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
         task.alertOption = selectedAlertOption
         do {
             try viewContext.save()
         } catch {
             print(error.localizedDescription)
         }
         
         presentationMode.wrappedValue.dismiss()
     }, label: { Text("Save") }))
     .navigationTitle(Text("Edit Task"))
 }
 */
struct TaskSettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var task: Task
    
    @State private var taskName: String
    @State private var description: String
    @State private var selectDate = Date()
    @State private var selectTime = Date()
    @State private var selectedPriority: TaskPriority
    @State private var selectedAlertOption = "None"
    
    let alertOptionsList = ["None", "5 Seconds before", "5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before"]
    
    init(task: Task) {
        self.task = task
        self._taskName = State(initialValue: task.title ?? "")
        self._description = State(initialValue: task.taskDescription ?? "")
        self._selectDate = State(initialValue: task.dueDate ?? Date())
        self._selectTime = State(initialValue: task.dueTime ?? Date())
        self._selectedPriority = State(initialValue: TaskPriority(rawValue: task.priority ?? "Medium") ?? .medium)
        self._selectedAlertOption = State(initialValue: task.alertOption ?? "None")
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
                // User can pick between: Low, Medium, High (Medium by default)
                Picker(selection: $selectedPriority, label: Text("Priority")) {
                    ForEach(TaskPriority.allCases, id: \.self) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            Section(header: Text("Notification Options")) {
                Picker("Set Alert", selection: $selectedAlertOption) {
                    ForEach(alertOptionsList, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.menu)
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
            task.alertOption = selectedAlertOption
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

