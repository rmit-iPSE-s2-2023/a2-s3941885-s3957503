import SwiftUI

struct MainTabView: View {
    @State var selectedTab = "house.fill"
    @Namespace var animation
    @State var xAxis: CGFloat = 0

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            // Switch views based on selectedTab
            switch selectedTab {
            case "house.fill":
                NavigationView {
                    ListView()
                }
                
            case "chart.bar.fill":
                NavigationView {
                    StatisticView()
                }
                
            default:
                NavigationView {
                    ListView()
                }
            }
            
            // Use the CustomTabBar from your Home view
            CustomTabBar(selectedTab: $selectedTab, xAxis: $xAxis, animation: animation)
        }
        .ignoresSafeArea()
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        return MainTabView()
            .environment(\.managedObjectContext, context)
    }
}

