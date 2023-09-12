//
//  TasksView.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 12/8/2023.
//
import SwiftUI

struct ListModel: Identifiable {
    let id = UUID()
    var listTitle: String
    var listColor: Color
}
struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var searchText: String = ""
    
    var filteredLists: [ListModel] {
        listViewModel.lists.filter {
            searchText.isEmpty ? true : $0.listTitle.lowercased().contains(searchText.lowercased())
        }
    }
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search...", text: $searchText)
                        .disableAutocorrection(true)
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(15)
                .padding([.horizontal], 15)
                .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 4)
                
                HStack {
                    TaskNumView(taskCategory: "In Progress", iconName: "checklist", iconBackgroundColor: Color(red: 0.24, green: 0.8, blue: 0.98), numberOfTasks: 0)
                    TaskNumView(taskCategory: "Completed", iconName: "checklist", iconBackgroundColor: Color(red: 0.99, green: 0.75, blue: 0.28), numberOfTasks: 0)
                }
                .padding([.horizontal], 15) // Add padding around the HStack
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                Text("My Lists")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                ForEach(filteredLists) { listItem in
                    MyListsView(iconName: "gearshape", // Default icon
                                iconBackgroundColor: listItem.listColor,
                                listName: listItem.listTitle,
                                listColor: listItem.listColor,
                                numOfTaskInList: 0, //Hardcode, this should count the amount of tasks in a list
                                id: listItem.id)
                }
                
                
                Spacer()
            }
            .navigationBarItems(trailing: NavigationLink(destination: AddListView(), label: { Text("Add List") }))
            .navigationTitle("Home")
        }
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(ListViewModel())
    }
}
