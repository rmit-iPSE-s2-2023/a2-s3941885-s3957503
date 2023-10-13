import SwiftUI
/**
 A view that provides an interactive button toggle. It acts similarly to a switch, where the user can toggle between two states: on and off.

 The button visually changes its appearance based on its current state. When it's on, the button displays a checkmark inside a circle, and its background color becomes blue. When it's off, the button shows an empty circle and adopts a lighter background.
 
 Usage:
 To use this view, you need to initialize it with a title and a binding to a boolean state. For example:
 ```swift
 @State private var isFeatureEnabled = false

 ButtonToggleView(title: "Enable Feature", isOn: $isFeatureEnabled)
```
 Features:
 - Provides an immediate visual feedback of the toggle state.
 - Can be initialized with a custom title.
 - Changes its appearance based on the state, giving users a clear indication of the toggle's current status.

 Properties:
 - `title`: The title or label of the button.
 - `isOn`: A binding to a boolean that determines whether the toggle is on (`true`) or off (`false`).

 Note:
 Make sure to provide a binding ($) to the isOn property so that the ButtonToggleView can read and modify the provided boolean state.
 ```swift
 var body: some View {
     Button(action: {
         isOn.toggle()
     }) {
         HStack {
             Text(title)
                 .foregroundColor(isOn ? .white : .primary)
             Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                 .foregroundColor(isOn ? .white : .primary)
         }
         .padding(.horizontal, 10)
         .padding(.vertical, 5)
         .background(isOn ? Color.blue : Color(.systemGray6))
         .cornerRadius(8)
     }
 }
 */
struct ButtonToggleView: View {
    var title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: {
            isOn.toggle()
        }) {
            HStack {
                Text(title)
                    .foregroundColor(isOn ? .white : .primary)
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isOn ? .white : .primary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(isOn ? Color.blue : Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

