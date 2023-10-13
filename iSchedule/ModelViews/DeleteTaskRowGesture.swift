import SwiftUI
/**
 A view that provides an interactive swipe-to-delete gesture for tasks. When a user swipes a task row to the left, a red delete button (trash icon) is revealed. If the swipe is significant enough, a confirmation alert is presented to ensure the user really wants to delete the task.
 
 Usage:
 To use this view, you need to initialize it with a task and a deletion closure. For instance:
 ```swift
 DeleteTaskRowGesture(task: someTask) {
     // Handle the task deletion here
 }
```
 Features:
 - Swipe to reveal a delete button.
 - Springy animation while swiping.
 - Presents a confirmation alert upon a sufficient swipe to avoid accidental deletions.
 - Calls a provided deletion action if the user confirms the deletion.

 Properties:
 - `task`: The task that the row represents.
 - `onDelete`: A closure that is called when the user confirms the deletion of the task. This should handle the deletion logic.
 
 Note:
 It's essential to handle the actual deletion logic within the onDelete closure to maintain data consistency and provide immediate feedback to the user.
 ```swift
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
                                 self.showingDeletionAlert = true
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
         .alert(isPresented: $showingDeletionAlert) {
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
 */
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
                                self.showingDeletionAlert = true
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
        .alert(isPresented: $showingDeletionAlert) {
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
