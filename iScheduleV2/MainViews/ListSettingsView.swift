import SwiftUI

struct ListSettingsView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var listColor: Color
    @State var listName: String
    var listID: UUID // Identifier for the list to be edited
    
    var body: some View {
        Form {
            Section("List Details") {
                TextField("Enter List Name", text: $listName)
                    .multilineTextAlignment(.center)
                    .frame(height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Assuming you have a CustomColorPicker
                CustomColorPicker(listColor: $listColor)
            }
        }
        .navigationBarItems(trailing: Button("Save") {
            if !listName.isEmpty {
                listViewModel.updateList(listID: listID, listName: listName, listColor: listColor)
                presentationMode.wrappedValue.dismiss()
            }
        })

        .navigationTitle(Text("List Settings"))
    }
}

// Preview
struct ListSettings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListSettingsView(listColor: Color.red, listName: "Sample List", listID: UUID())
                .environmentObject(ListViewModel())
        }
    }
}

