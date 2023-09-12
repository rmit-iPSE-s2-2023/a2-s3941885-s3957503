//
//  ListModel.swift
//  iScheduleV2
//
//  Created by Esmatullah Akhtari on 25/8/2023.
//
import SwiftUI
import Foundation

class ListViewModel: ObservableObject {
    @Published var lists: [ListModel] = [
        ListModel(listTitle: "Assignments", listColor: Color.red),
        ListModel(listTitle: "House Chores", listColor: Color.blue),
    ]
    
    func addList(listName: String, listColor: Color) {
        let newList = ListModel(listTitle: listName, listColor: listColor)
        lists.append(newList)
    }
    func updateList(listID: UUID, listName: String, listColor: Color) {
        if let index = lists.firstIndex(where: { $0.id == listID }) {
            lists[index].listTitle = listName
            lists[index].listColor = listColor
        }
    }

}


