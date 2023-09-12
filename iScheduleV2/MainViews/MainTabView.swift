import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab (ListView)
            NavigationView {
                ListView()
            }
            .environmentObject(listViewModel)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // Profile Tab (ProfileView)
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(1)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(ListViewModel())
            .environmentObject(TaskViewModel())
    }
}

