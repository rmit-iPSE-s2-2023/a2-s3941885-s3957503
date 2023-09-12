//
//  TaskModelView.swift
//  iSchedule
//
//  Created by Edward on 22/8/2023.
//
import Foundation
class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = [
        TaskModel(name: "Iphone assignment 1", status: .inProgress, description: "Description for Iphone assignment 1", dueDate: Date().addingTimeInterval(86400), time: Date()),
        TaskModel(name: "Algo quiz 6", status: .completed, description: "Description for Algo quiz 6", dueDate: Date().addingTimeInterval(172800), time: Date()),
        TaskModel(name: "Algo assigment 1", status: .inProgress, description: "Description for Algo assigment 1", dueDate: Date().addingTimeInterval(259200), time: Date())
    ]
    
    func addTask(name: String, dueDate: Date, description: String) {
        let newTask = TaskModel(name: name, status: .inProgress, description: description, dueDate: dueDate, time: dueDate)
        tasks.append(newTask)
    }

}
