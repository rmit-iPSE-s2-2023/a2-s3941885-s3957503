import SwiftUI
import CoreData
/**
A view designed for users to add a new `TaskList`entity to the CoreData database.

Description:
    - Input for the name of the list.
    - Horizontal scroll view that presents different color options for the list.
    - Selected color highlights the background of the input text field for visual confirmation.

Upon saving, the new list's name and color are saved into the CoreData context.
Note:
 - The color is saved as a string description in the CoreData model.
 - Therefore, when retrieving and using this color, appropriate conversion will be needed.
 
 ```swift
 var body: some View {
     Form {
         TextField("Enter List Name", text: $listName)
             .multilineTextAlignment(.center)
             .frame(height: 100)
             .background(selectedColor)
             .clipShape(RoundedRectangle(cornerRadius: 12))
             .fontWeight(.bold)
             .font(.system(size: 30))
             .padding()

         Text("Choose Your List Color")
             .fontWeight(.semibold)
             .padding(.top)
         
         ScrollView(.horizontal) {
             HStack {
                 ForEach(colors, id: \.self) { color in
                     Circle()
                         .foregroundColor(color)
                         .frame(width: 45, height: 45)
                         .opacity(color == selectedColor ? 0.5 : 1.0)
                         .onTapGesture {
                             self.selectedColor = color
                         }
                 }
             }
             .padding()
             .background(Color(UIColor.systemBackground))
             .cornerRadius(20)
             .padding(.horizontal)
         }
     }
     .navigationBarItems(trailing: Button("Save") {
         addList()
     })
     .navigationTitle("Add List")
 }
 */
struct AddListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var listName: String = ""
    @State private var selectedColor: Color = Color.orange
    
    let colors: [Color] = [.orange, .red, .yellow, .green, .blue, .purple, .gray, .pink]

    var body: some View {
        Form {
            TextField("Enter List Name", text: $listName)
                .multilineTextAlignment(.center)
                .frame(height: 100)
                .background(selectedColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .fontWeight(.bold)
                .font(.system(size: 30))
                .padding()

            Text("Choose Your List Color")
                .fontWeight(.semibold)
                .padding(.top)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .foregroundColor(color)
                            .frame(width: 45, height: 45)
                            .opacity(color == selectedColor ? 0.5 : 1.0)
                            .onTapGesture {
                                self.selectedColor = color
                            }
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .padding(.horizontal)
            }
        }
        .navigationBarItems(trailing: Button("Save") {
            addList()
        })
        .navigationTitle("Add List")
    }

    private func addList() {
        let newList = TaskList(context: viewContext)
        newList.name = listName
        newList.colorString = selectedColor.description // Save the color as a String
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving new list: \(error)")
        }
    }
}

struct AddListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        return NavigationView {
            AddListView().environment(\.managedObjectContext, context)
        }
    }
}

