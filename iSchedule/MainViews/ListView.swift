import SwiftUI
import CoreData

/**
 `ListView` displays a list of user-created tasks and provides functionalities like search, adding new lists, and deleting existing lists. It fetches the `TaskList` entities from Core Data.

 ## Overview:
 - **Search Bar:** The view integrates a ``SearchBarView`` to enable users to search and filter task lists based on their names. Filtering is real-time and adjusts as the user types.
 - **Task Lists:** All the task lists stored in Core Data are fetched and displayed in this view. Each list is represented using a ``ListRow`` view.
 - **Navigation:** The top navigation bar contains an "Add List" button to navigate users to a new view (``AddListView``) for creating a new task list.
 - **Swipe to Delete:** Each ``ListRow`` item supports a swipe-to-delete action, allowing users to quickly delete a task list.
 
 ## Usage:
 To integrate the `ListView` into a SwiftUI view, use:
 ```swift
 ListView().environment(\.managedObjectContext, context)
 ```
 
 ## Body:
 The main view consists of:
 - A `SearchBarView` at the top.
 - A title "My Lists".
 - A ForEach loop that displays each task list using the `ListRow` view.
 - A navigation link (positioned in the top navigation bar) to the `AddListView`.
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
 ```
 
 ## Notes:
 Ensure the Core Data entity for TaskList contains a property named name which represents the name of the task list.
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
