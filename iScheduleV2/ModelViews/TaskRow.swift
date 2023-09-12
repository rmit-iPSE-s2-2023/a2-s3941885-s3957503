//
//  TaskRow.swift
//  iSchedule
//
//  Created by Edward on 22/8/2023.
//

import SwiftUI
struct TaskRow: View {
    @Binding var task: TaskModel
    let formatter: DateFormatter
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    var body: some View {
        NavigationLink(destination: TaskSettingsView(task: $task)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(task.name)
                }
                Spacer()
                Text("\(formatter.string(from: task.dueDate)), \(timeFormatter.string(from: task.time))")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                Toggle("", isOn: Binding(
                    get: { task.status == .completed },
                    set: { newValue in
                        task.status = newValue ? .completed : .inProgress
                    }))
                .toggleStyle(CheckboxToggleStyle())
            }
        }
    }
}
