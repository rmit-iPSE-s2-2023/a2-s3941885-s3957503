import SwiftUI
import CoreData

/**
 `ListView` displays lists created by the user. It fetches the `TaskList` entities from Core Data.

 ## Usage:
 ```swift
 ListView().environment(\.managedObjectContext, context)
 ```
 
 ## Features:
 - Search Bar: The view integrates SearchBarView to filter task lists based on their name. The lists are filtered in real-time as the user types in the search bar.
 - Navigation: The navigation bar has an "Add List" button on the trailing side, which, when tapped, will lead the user to the AddListView.
 - List Display: The main body of the view shows the fetched task lists. Each task list is represented using a ListRow view.
 - Swipe to Delete: Each ListRow supports swipe-to-delete functionality, allowing the user to swipe from right to left to reveal a delete action.
 
 ## Properties:
 - `allLists`: A `FetchedResults` object that fetches all `TaskList` entities from Core Data, sorted by the name of the task list.
 - `searchText`: A `State` property that holds the string entered by the user in the search bar.

 ## Notes:
 - Ensure the Core Data entity for TaskList contains a property named name which represents the name of the task list.
 - The SearchBarView must be a custom view that supports text input for searching purposes.
 - The ListRow is assumed to be a custom view designed to represent and display each TaskList entity.
 - Always ensure that proper error handling is implemented when dealing with Core Data operations to prevent data loss or app crashes.
 
 ```swift
 var body: some View {
     VStack {
         SearchBarView(text: $searchText)
             .padding([.horizontal], 15)
         Text("My Lists")
             .font(.title2)
             .fontWeight(.semibold)
             .foregroundColor(Color.primary)
             .frame(maxWidth: .infinity, alignment: .leading)
             .padding(.leading)
         //Loop for fetching the lists and creating a list bar from ListRow (MyListsView as the model, while having the gesture logic inside)
         ForEach(allLists.filter({ searchText.isEmpty ? true : $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }), id: \.self) { list in
             ListRow(taskList: list, onDelete: {
                 self.deleteList(at: [allLists.firstIndex(of: list)!])
             })
         }
         Spacer()
     }
     
     .navigationBarItems(trailing: NavigationLink(destination: AddListView().environment(\.managedObjectContext, self.viewContext), label: { Text("Add List") }))
     .navigationTitle("Home")
 }
 */

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch request for all `TaskList` entities, sorted by name.
    @FetchRequest(
        entity: TaskList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )
    private var allLists: FetchedResults<TaskList>
    
    @State private var searchText: String = ""
    
    private func deleteList(at offsets: IndexSet) {
        for index in offsets {
            let list = allLists[index]
            viewContext.delete(list)
        }
        do {
            try viewContext.save()
            viewContext.refreshAllObjects()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            SearchBarView(text: $searchText)
                .padding([.horizontal], 15)
            Text("My Lists")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            //Loop for fetching the lists and creating a list bar from ListRow (MyListsView as the model, while having the gesture logic inside)
            ForEach(allLists.filter({ searchText.isEmpty ? true : $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }), id: \.self) { list in
                ListRow(taskList: list, onDelete: {
                    self.deleteList(at: [allLists.firstIndex(of: list)!])
                })
            }
            Spacer()
        }
        
        .navigationBarItems(trailing: NavigationLink(destination: AddListView().environment(\.managedObjectContext, self.viewContext), label: { Text("Add List") }))
        .navigationTitle("Home")
    }
    
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        return ListView()
            .environment(\.managedObjectContext, context)
    }
}
