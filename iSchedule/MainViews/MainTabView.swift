import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab (ListView)
            NavigationView {
                ListView()
            }
            
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // Profile Tab (ProfileView)
            NavigationView {
                StatisticView()
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Statistics")
            }
            .tag(1)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        return MainTabView()
            .environment(\.managedObjectContext, context)
    }
}
