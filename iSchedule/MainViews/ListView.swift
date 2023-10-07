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

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        return ListView()
            .environment(\.managedObjectContext, context)
    }
}
