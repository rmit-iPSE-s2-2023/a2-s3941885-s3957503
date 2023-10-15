import SwiftUI
/**
 A view that encapsulates a single row in a task list, it is designed to hold the task or list details, it has a swipe-to-delete functionality.

 This view displays a single task list. When the user swipes left on the row, a delete button is revealed. Swiping past a certain threshold triggers an alert, allowing the user to confirm the deletion action.

 Usage:
 ```swift
 ListRow(taskList: myTaskList, onDelete: {
     // Handle deletion action
 })
```
 
 ```swift
 var body: some View {
     ZStack {
         // Main Content
         MyListsView(taskList: taskList)
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
     .alert(isPresented: $showingDeletionAlert) { // 3. Alert modifier
         Alert(
             title: Text("Delete Task"),
             message: Text("Are you sure you want to delete this list?"),
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
 
 ## Note:
 This view is dependent on the CoreData entity TaskList and its related attributes. It also relies on an external view, ListSettingsView, to manage task settings.
 */
struct ListRow: View {
    var taskList: TaskList
    var onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var showingDeletionAlert = false
    
    var body: some View {
        ZStack {
            // Main Content
            MyListsView(taskList: taskList)
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
        .alert(isPresented: $showingDeletionAlert) { // 3. Alert modifier
            Alert(
                title: Text("Delete Task"),
                message: Text("Are you sure you want to delete this list?"),
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

