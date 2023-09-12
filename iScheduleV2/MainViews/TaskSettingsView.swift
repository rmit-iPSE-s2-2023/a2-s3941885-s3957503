//  Created by Edward on 13/8/2023.
import Foundation
import SwiftUI

struct TaskSettingsView: View {
    @Binding var task: TaskModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section("Task Details") {
                TextField("Title", text: $task.name)
                DatePicker("Date", selection: $task.dueDate, displayedComponents: [.date])
                DatePicker("Time", selection: $task.time, displayedComponents: [.hourAndMinute])
            }

            Section("Description") {
                TextEditor(text: $task.description)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 1)
                    .frame(height: 100)
            }

        }
        .navigationBarItems(trailing: Button("Save") {
            presentationMode.wrappedValue.dismiss()
        })
        .navigationTitle(Text("Task Settings"))
    }
}

struct TaskSettings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskSettingsView(task: .constant(TaskModel(name: "Sample Task", status: .inProgress, description: "This is a sample description", dueDate: Date(), time: Date())))
        }
    }
}
