import SwiftUI
/**
 A simple and reusable view that provides a visual representation of a search bar. The primary use case of this view is to capture and reflect user input for search-related functionalities.

 ##Usage:
 To use this view, simply initialize it with a bound text property. For instance:
 ```swift
 @State private var searchText = ""
 SearchBarView(text: $searchText)
 ```
 
 ##Features:
 - An embedded magnifying glass icon to visually indicate search capabilities.
 - A text field to accept user input for search queries.
 - Disables autocorrection to prevent unwanted suggestions during a search.

 
 ```swift
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
 */
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
