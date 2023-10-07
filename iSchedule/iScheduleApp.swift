import SwiftUI

@main
struct iScheduleApp: App {
    
    let persistentContainer = CoreDataManager.shared.persistentContainer
    var body: some Scene {
        WindowGroup {
            MainTabView().environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}

