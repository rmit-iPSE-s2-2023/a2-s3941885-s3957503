import SwiftUI
import CoreData
/**
 `AddListView` allows users to create a new TaskList entity to be saved into the CoreData database. It provides an interface for users to enter the name of the list and choose a color for the list.
 
 ## Overview:
 When the user navigates to this view, they can specify:
 - Name of the list.
 - Different color options for the list with a horizontal scroll view.
 - Selected color highlights the background of the input text field for visual confirmation.
 
 ## Usage:
 To use AddListView, you can simply add it within a NavigationView for proper navigation:
 ```swift
 NavigationView {
     AddListView()
 }
 ```
 
 ## Body:
 The view also includes a Save button in the navigation bar. When pressed, this button saves the entered list name and the selected color into the CoreData context.
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
 ```
 
 ## Notes:
 - Color Storage: Although SwiftUI uses the Color type for rendering, CoreData does not directly support storing this type. Instead, this view saves colors as string descriptions in the CoreData model. When retrieving and using this color in the future, an appropriate conversion from the string back to a Color will be necessary.

 - Color Choices: The colors array defines available colors for list customization. These are: orange, red, yellow, green, blue, purple, gray, and pink.

 - Saving the List: Upon pressing the Save button, the list name and the color string description are saved to a new TaskList entity in the CoreData context. If an error occurs during this save operation, it is printed to the console.

 - Closing the View: After successfully saving the new list, the view is dismissed, returning the user to the previous screen.
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

