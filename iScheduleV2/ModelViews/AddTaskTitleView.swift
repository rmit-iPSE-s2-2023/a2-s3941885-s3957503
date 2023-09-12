//
//  AddTaskTitleView.swift
//  iSchedule
//
//  Created by Esmatullah Akhtari on 12/8/2023.
//

import SwiftUI

struct AddTaskTitleView: View {
    @Binding var taskContent: String
    var title: String
    var placeHolder: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.semibold)
            TextField(placeHolder, text: $taskContent)
                .frame(height: 20)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary, lineWidth: 2)
                )
        }
    }
}
