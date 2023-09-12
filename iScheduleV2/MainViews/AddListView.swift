//
//  AddListView.swift
//  iSchedule
//
//  Created by Edward on 12/8/2023.
//

import SwiftUI

struct AddListView: View {
    @EnvironmentObject var listViewModel : ListViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var listColor : Color = Color.orange
    @State var listName: String = ""
    
    var body: some View {
        Form {
            TextField("Enter List Name", text: $listName)
                .multilineTextAlignment(.center)
                .frame(height: 100)
                .background(listColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .fontWeight(.bold)
                .font(.system(size: 30))
                .padding()
            
            Text("Choose Your List Color")
                .fontWeight(.semibold)
                .padding(.top)
            
            CustomColorPicker(listColor: $listColor)
        }
        .padding()
        .navigationBarItems(trailing: Button(action: {
            listViewModel.addList(listName: listName, listColor: listColor)
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
        }))
        .navigationTitle("Add List")
    }
}

struct AddList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddListView()
                .environmentObject(ListViewModel())
        }
    }
}

