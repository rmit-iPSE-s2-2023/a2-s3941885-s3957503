import SwiftUI

struct DeleteTaskRowGesture: View {
    var task: Task
    var onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var showingDeletionAlert = false
    
    var body: some View {
        ZStack {
            // Main Content
            TaskRow(task: task)
                .background(Color.white)
                .offset(x: offset)
                .gesture(DragGesture()
                    .onChanged { gesture in
                        let translation = gesture.translation.width
                        self.offset = min(0, translation)
                    }
                    .onEnded { gesture in
                        withAnimation {
                            if self.offset < -50 {
                                self.showingDeletionAlert = true // 2. Set to true instead of onDelete
                            } else {
                                self.offset = 0
                            }
                        }
                    }
                )
            
            // Delete Button
            HStack {
                Spacer()
                Image(systemName: "trash.fill")
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .opacity(Double(-offset / 50))
            .padding(.trailing, -offset > 50 ? 0 : 50 + offset)
        }
        .alert(isPresented: $showingDeletionAlert) { // 3. Alert modifier
            Alert(
                title: Text("Delete Task"),
                message: Text("Are you sure you want to delete this task?"),
                primaryButton: .destructive(Text("Delete")) {
                    self.onDelete()
                },
                secondaryButton: .cancel {
                    withAnimation {
                        self.offset = 0
                    }
                }
            )
        }
    }
}
