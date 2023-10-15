import SwiftUI
import CoreData
/**
 `ListSettingsView` provides an interface for users to edit and manage the settings of a specific `TaskList`. This view can be accessed by clicking on the gearshape symbol on the ``ListView``.  It is meant to offer intuitive controls for adjusting common list properties, like its name and color.
 
 ## Overview:
  - **Purpose:** Enable users to customize the appearance and title of a `TaskList`.
  - **Access:** The view can be invoked by tapping on the gearshape symbol from the ``ListView``.
  - **Interactions:** Allows for text input to change the name, and color selection through a horizontal color palette.
  - **Save Mechanism:** Uses a "Save" button on the navigation bar to persist any changes made.

 ## Usage:
 To utilize the `ListSettingsView`, provide an instance of `TaskList` during initialization. This view will then display the current details of the list, allowing the user to edit as necessary.
 ```swift
 let taskList: TaskList = // Fetch or get your TaskList instance from Core Data
 ListSettingsView(existingList: taskList)
 ```
 
  ## Body:
  The view's body is composed mainly of a `Form` that has:
  - A `TextField` for the list name.
  - A descriptive text guiding users to choose a color.
  - A horizontally scrollable list of color options.
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
         updateList()
     })
     .navigationTitle("List Settings")
 }
 ```
 
 ## Notes:
 Always ensure that the existingList passed to ListSettingsView during initialization is a valid instance from Core Data to prevent potential crashes or data inconsistencies.
 */
struct ListSettingsView: View {
    /// The Core Data context used to manage the persisted data.
    @Environment(\.managedObjectContext) private var viewContext
    
    /// Represents the presentation mode of the view, allowing for the dismissal of this view.
    @Environment(\.presentationMode) var presentationMode
    
    /// The specific `TaskList` that this view will modify.
    @ObservedObject var existingList: TaskList
    
    /// A bindable property holding the name of the list, which the user can modify.
    @State private var listName: String = ""
    
    /// A bindable property holding the selected color for the list. Displayed as the background of the text field.
    @State private var selectedColor: Color = Color.orange
    
    /// A predefined set of colors available for the user to choose from for their list.
    let colors: [Color] = [.orange, .red, .yellow, .green, .blue, .purple, .gray, .pink]
    init(existingList: TaskList) {
        self.existingList = existingList
        _listName = State(initialValue: self.existingList.name ?? "")
        
        if let colorString = self.existingList.colorString {
            _selectedColor = State(initialValue: colorFromString(colorString))
        }
    }

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
            updateList()
        })
        .navigationTitle("List Settings")
    }

    private func updateList() {
        existingList.name = listName
        existingList.colorString = selectedColor.description
        viewContext.refresh(existingList, mergeChanges: true)

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error updating list: \(error)")
        }
    }

}

func colorFromString(_ colorString: String) -> Color {
    switch colorString {
    case "orange":
        return Color.orange
    case "red":
        return Color.red
    case "yellow":
        return Color.yellow
    case "green":
        return Color.green
    case "blue":
        return Color.blue
    case "purple":
        return Color.purple
    case "gray":
        return Color.gray
    case "pink":
        return Color.pink
    default:
        return Color.orange
    }
}
