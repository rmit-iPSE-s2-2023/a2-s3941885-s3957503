import SwiftUI
import CoreData

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch all TaskLists
    @FetchRequest(
        entity: TaskList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    )
    private var allLists: FetchedResults<TaskList>
    
    // Fetch all "In Progress" Tasks
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "status == %@", "In Progress")
    )
    private var inProgressTasks: FetchedResults<Task>
    
    // Fetch all "Completed" Tasks
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "status == %@", "Completed")
    )
    private var completedTasks: FetchedResults<Task>
    
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
        NavigationView {
            VStack {
                SearchBarView(text: $searchText)
                    .padding([.horizontal], 15)
                
                // Task Categories
                HStack {
                    TaskNumView(taskCategory: "In Progress", iconName: "checklist", iconBackgroundColor: Color.blue, numberOfTasks: inProgressTasks.count)
                    TaskNumView(taskCategory: "Completed", iconName: "checklist", iconBackgroundColor: Color.orange, numberOfTasks: completedTasks.count)
                }
                .padding([.horizontal], 15)
                
                Text("My Lists")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                ForEach(allLists.filter({ searchText.isEmpty ? true : $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }), id: \.self) { list in
                        DeleteListGesture(taskList: list, onDelete: {
                            self.deleteList(at: [allLists.firstIndex(of: list)!])
                        })
                    }
                Spacer()
            }
            
            .navigationBarItems(trailing: NavigationLink(destination: AddListView().environment(\.managedObjectContext, self.viewContext), label: { Text("Add List") }))
            .navigationTitle("Home")
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        return ListView()
            .environment(\.managedObjectContext, context)
    }
}
