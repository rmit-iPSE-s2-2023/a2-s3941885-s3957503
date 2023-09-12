//
//  CustomColorPicker.swift
//  iSchedule
//
//  Created by Edward on 13/8/2023.
//

import SwiftUI

struct CustomColorPicker: View {
    @Binding var listColor: Color
    private let colors: [Color] = [.orange, .red, .yellow,  .purple, .blue, .indigo, .green, .mint]
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .foregroundColor(color)
                        .frame(width: 45, height:  45)
                        .opacity(color == listColor ? 0.5 : 1.0)
                        .onTapGesture {
                            listColor = color
                        }
                }
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(20)
            .padding(.horizontal)
        }
    }
}

struct CustomColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPicker(listColor: .constant(.blue))
    }
}
