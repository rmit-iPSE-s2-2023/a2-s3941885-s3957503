import SwiftUI

/**
 `MainTabView` serves as the main navigation controller for the app, facilitating navigation between the major sections, such as the list of tasks and statistics.
 
 ## Overview:
 This  view orchestrates the overall navigation and presentation of the two main subviews, namely:
 - `ListView`: Displaying user's lists and detailed task information.
 - `StatisticView`: Showcasing various statistics related to the user's lists and tasks.
 The `MainTabView` employs a `CustomTabBar` consistently displayed at the bottom of the screen for navigation between the sections. Depending on the `selectedTab`, it dynamically changes the main content display between the `ListView` and `StatisticView`.
 
 ## Usage:
 Include the MainTabView as the initial view in the SwiftUI app, ensuring to provide the relevant Core Data context if required:
 ```swift
 MainTabView().environment(\.managedObjectContext, context)
 ```
 
 ## Body:
 The body of the `MainTabView` utilizes a `ZStack` to layer its content and custom tab bar. A `switch` statement within the `ZStack` checks `selectedTab` to decide which view to display:
 ```swift
 ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
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
     CustomTabBar(selectedTab: $selectedTab, xAxis: $xAxis, animation: animation)
 }
 .ignoresSafeArea()
 ```
 
 ## Notes:
 Ensure that:
 - The `CustomTabBar`  is properly configured and accepts the required bindings.
 - The `ListView`  and `StatisticView` are independent and don't rely on the global state of MainTabView.
*/
struct MainTabView: View {
    @State var selectedTab = "house.fill"
    @Namespace var animation
    @State var xAxis: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
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

