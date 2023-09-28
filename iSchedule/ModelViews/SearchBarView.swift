//
//  SearchBarView.swift
//  iSchedule
//
//  Created by Edward on 3/10/2023.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search...", text: $text)
                .disableAutocorrection(true)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.20), radius: 2, x: 0, y: 4)
    }
}
