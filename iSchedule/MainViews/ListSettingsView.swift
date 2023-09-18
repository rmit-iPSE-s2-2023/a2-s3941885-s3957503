import SwiftUI
import CoreData

struct ListSettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var existingList: TaskList
    @State private var listName: String = ""
    @State private var selectedColor: Color = Color.orange

    let colors: [Color] = [.orange, .red, .yellow, .green, .blue, .purple, .gray, .pink]

    init(existingList: TaskList) {
        self.existingList = existingList
        _listName = State(initialValue: self.existingList.name ?? "")
        
        if let colorString = self.existingList.colorString {
            // Assume a function named colorFromString exists to convert your stored string to a SwiftUI Color
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
        existingList.colorString = selectedColor.description // assuming .description gives a correct string representation of color
        viewContext.refresh(existingList, mergeChanges: true) // Refresh the existing list

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
        // Default color if the string doesn't match any known color
        return Color.orange
    }
}
