import SwiftUI

struct MyListsView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    var iconName: String = "checklist"
    var iconBackgroundColor: Color = Color(red: 0.24, green: 0.8, blue: 0.98)
    var listName: String = "In progress"
    var listColor: Color = Color.blue
    var numOfTaskInList: Int = 0
    var id = UUID()
    @State private var showListSettings = false

    var body: some View {
        HStack {
            VStack {
                NavigationLink(destination: ListSettingsView(listColor: iconBackgroundColor, listName: listName, listID: id).environmentObject(listViewModel)) {
                    Image(systemName: "\(iconName)")
                        .frame(width: 35, height: 35)
                        .background(iconBackgroundColor)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        .font(.system(size: 20))
                }
                .padding([.leading], 20)
            }

            VStack(alignment: .center) {
                NavigationLink(destination: TaskView().environmentObject(taskViewModel)) {
                    Text("\(listName)")
                        .padding([.top])
                        .padding([.bottom], -1)
                }

                Text("\(numOfTaskInList)")
                    .fontWeight(.bold)
            }
            .font(.system(size: 20))
            .frame(maxWidth: .infinity)
            .padding([.trailing], 40)

            Spacer() // Added Spacer

        }
        .frame(width: 400, height: 80)  // Increased the width and height
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .padding([.bottom], 7)
    }
}

struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        MyListsView(listName: "Sample List", listColor: Color.blue)
            .environmentObject(ListViewModel())
            .environmentObject(TaskViewModel())
    }
}

