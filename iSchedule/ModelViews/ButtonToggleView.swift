import SwiftUI
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

