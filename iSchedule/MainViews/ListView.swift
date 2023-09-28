//Possible further implementations
//Maybe create a full combined tasks for inprogress and completed
//Sort by day created, alphabetically and manual drag and drop sorting
//dummy commit
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
                        SwipeToDeleteView(taskList: list, onDelete: {
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
struct SwipeToDeleteView: View {
    var taskList: TaskList
    var onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Main Content
            MyListsView(taskList: taskList)
                .background(Color.white)
                .offset(x: offset)
                .gesture(DragGesture()
                    .onChanged { gesture in
                        let translation = gesture.translation.width
                        self.offset = min(0, translation)
                    }
                    .onEnded { gesture in
                        withAnimation {
                            if self.offset < -50 {
                                self.onDelete()
                            }
                            self.offset = 0
                        }
                    }
                )
            
            // Delete Button
            HStack {
                Spacer()
                Image(systemName: "trash.fill")
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .opacity(Double(-offset / 50))
            .padding(.trailing, -offset > 50 ? 0 : 50 + offset)
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
