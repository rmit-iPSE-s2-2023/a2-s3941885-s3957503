//
//  AddTasksView.swift
//  iSchedule
//
//  Created by Edward on 22/8/2023.
//

import Foundation
import SwiftUI

struct AddTasksView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var taskName: String = ""
    @State private var description: String = ""
    @State private var selectDate = Date()
    @State private var selectTime = Date()

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
                AddTaskTitleView(taskContent: $taskName, title: "Title", placeHolder: "Enter Title")

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
            }

            Section("Description") {
                TextEditor(text: $description)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 1)
                    .frame(height: 100)
            }
        }
        .navigationBarItems(trailing: Button(action: {
            taskViewModel.addTask(name: taskName, dueDate: combinedDateTime, description: description)
            presentationMode.wrappedValue.dismiss()  // Close the AddTasksView after adding the task
        }, label: { Text("Save") }))
        .navigationTitle(Text("Add Task"))
    }
}

struct AddTasksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddTasksView()
                .environmentObject(TaskViewModel()) // Ensure the preview has access to the view model
        }
    }
}
