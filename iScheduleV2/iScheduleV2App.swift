//
//  iScheduleApp.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 12/8/2023.
//

import SwiftUI

@main
struct iScheduleV2App: App {
    @StateObject var taskViewModel = TaskViewModel()
    @StateObject var listViewModel = ListViewModel()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(listViewModel)
                .environmentObject(taskViewModel)
        }
    }
}
