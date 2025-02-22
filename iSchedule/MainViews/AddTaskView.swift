import SwiftUI
import CoreData
import UserNotifications
/**
 `AddTaskView` provides a form-based interface to add new tasks to a specific `TaskList`. Users can specify various task details, including the task title, due date and time, priority, notification options, and an optional description.

 ## Overview:
 When the user navigates to this view, they can specify:
 - Task Title
 - Task Due Date and Time
 - Task Priority to categorize task urgency (medium by default).
 - Notification options to alert the user of upcoming tasks.
 - Task Description (optional)
 
 ## Usage:
 To use AddTaskView, you can simply add it within a NavigationView for proper navigation:
 ```swift
 NavigationView {
     AddTaskView()
 }
```
 
 ## Body:
 ```swift
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
         addTask()
         presentationMode.wrappedValue.dismiss()
     }, label: { Text("Save") }).disabled(!isFormComplete))
     .onAppear{
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){
             allowed, error in
             
             //To test whether permission granted or no for showing notification.
             let permission = allowed ? "Showing notification permitted." : "Notification permission denied."
             print(permission)
         }
     }
     .navigationTitle(Text("Add Task"))
 }
 ```
 
 ## Notes:
 - TaskList Instance: When initializing AddTaskView, you must provide an instance of TaskList. The new task will be linked to this provided task list upon saving.
 - Form Validation: Users can only save the task if the title has been provided. The Save button is disabled until the title is filled out.
 - Date and Time Combining: The view combines the selected due date and due time into a single Date object to represent the full due date and time of the task.
 - Notification Authorization: When the view appears, it requests permission from the user to show notifications. This is handled using the UserNotifications framework. If the user denies permission, notifications will not be scheduled.
 - Saving and Notifications: Upon tapping the Save button, the task details are saved to the provided TaskList. If the user has chosen an alert option, a notification for the task will also be scheduled based on the selected alert time.
 - Custom Notification Scheduling: The notification scheduling logic, represented by the NotificationManager.scheduleAlert function, is assumed to be in another class or module called NotificationManager. Ensure that this function is correctly defined elsewhere to handle the scheduling of notifications.
 */
struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var selectedList: TaskList
    
    @State private var taskName: String = ""
    @State private var description: String = ""
    @State private var selectDate = Date()
    @State private var selectTime = Date()
    @State private var selectedPriority: TaskPriority = .medium
    
    @State private var selectedAlertOption = "None"
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
            addTask()
            presentationMode.wrappedValue.dismiss()
        }, label: { Text("Save") }).disabled(!isFormComplete))
        .onAppear{
            /*
             Using User Notification framework in SwiftUI to request displaying notification on the screen
             Requesting options [alert, sound, and badge].
            */
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){
                allowed, error in
                
                //To test whether permission granted or no for showing notification.
                let permission = allowed ? "Showing notification permitted." : "Notification permission denied."
                print(permission)
            }
        }
        .navigationTitle(Text("Add Task"))
    }
    
    private func addTask() {
        let newTask = Task(context: viewContext)
        newTask.title = taskName
        newTask.dueDate = selectDate
        newTask.dueTime = selectTime
        newTask.priority = selectedPriority.rawValue
        newTask.taskDescription = description
        newTask.status = "In Progress"
        newTask.taskList = selectedList  // Link the new task to the pre-defined selected TaskList
        
        do {
            try viewContext.save()
            print("Task saved successfully.")
            if selectedAlertOption != "None" {
                // Call the NotificationManager to schedule the notification
                NotficationManager.scheduleAlert(taskName: taskName, selectedDate: selectDate, selectedTime: selectTime, selectedAlertOption: selectedAlertOption)
            }
        } catch {
            print("Error saving task: \(error.localizedDescription)")
        }
    }
}


struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let persistedContainer = CoreDataManager.shared.persistentContainer
        NavigationView {
            AddTaskView(selectedList: TaskList())
                .environment(\.managedObjectContext, persistedContainer.viewContext)
        }
    }
}

