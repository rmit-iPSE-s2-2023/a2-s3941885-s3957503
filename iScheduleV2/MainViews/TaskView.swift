//
//  SwiftUIView.swift
//  iSchedule
//
//  Created by Edward on 21/8/2023.
// I modified AddTaskTitleView, TaskView, AddTasksView, TaskSettings
// I added TaskRow, CheckBoxToggle, TaskModelView
// This is should be connected to the assignment list on ListView
// The data is in TaskModelView
// You can add using Add Task button, and modify any details about the task by tapping on the task using TaskSettingsView
// Since the data is hard coded any data you create or modify will reset when you refresh the view
import SwiftUI

struct TaskModel: Identifiable {
    var id = UUID()
    var name: String
    var status: TaskStatus
    var description: String
    var dueDate: Date
    var time: Date
}

enum TaskStatus: String, CaseIterable {
    case inProgress = "In Progress"
    case completed = "Completed"
}

struct TaskView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy"
        return formatter
    }()

    @State private var searchText = ""
    @State private var selectedStatus: TaskStatus? = .inProgress
    @State private var showDescription: UUID? = nil

    var filteredIndices: [Int] {
        var result: [Int] = []

        for (index, task) in taskViewModel.tasks.enumerated() {
            if let filter = selectedStatus, task.status != filter {
                continue
            }
            if !searchText.isEmpty, !task.name.lowercased().contains(searchText.lowercased()) {
                continue
            }
            result.append(index)
        }

        return result
    }

    var body: some View {
        VStack {
            Picker("Filter", selection: $selectedStatus) {
                ForEach(TaskStatus.allCases, id: \.self) { status in
                    Text(status.rawValue).tag(Optional(status))
                }
                Text("All").tag(Optional<TaskStatus>.none)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            List {
                ForEach(filteredIndices, id: \.self) { index in
                    let taskBinding = $taskViewModel.tasks[index]
                    TaskRow(task: taskBinding, formatter: formatter)
                }
            }
            .navigationBarItems(trailing: NavigationLink(destination: AddTasksView(), label: { Text("Add Task") }))
            .navigationTitle(Text("My Tasks")) // put in a navigationview in order to see this
            .searchable(text: $searchText)
            .disableAutocorrection(true)
            
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
            .environmentObject(TaskViewModel())
    }
}
