import SwiftUI
/**
A custom toggle style designed to display a checkbox.

 ## Usage:
 To use this style with a toggle, apply the .toggleStyle(CheckboxToggleStyle()) modifier.
 For instance:
 ```swift
  Toggle("", isOn: $isOn).toggleStyle(CheckboxToggleStyle())
 ```
This style represents the "On" state with a checkmark inside a square and the "Off" state with just an empty square.

```swift
 struct CheckboxToggleStyle: ToggleStyle {
     func makeBody(configuration: Configuration) -> some View {
         Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
             .foregroundColor(configuration.isOn ? .blue : .gray)
             .onTapGesture {
                 configuration.isOn.toggle()
             }
     }
 }
*/
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
            .foregroundColor(configuration.isOn ? .blue : .gray)
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}
