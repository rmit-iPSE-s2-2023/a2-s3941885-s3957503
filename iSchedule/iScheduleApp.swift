import SwiftUI
/**
 The main application structure for `iScheduleApp`.
 
 This app is built using SwiftUI and manages its data using CoreData.
 It uses the `MainTabView` as the primary view and injects the CoreData `managedObjectContext` into the environment
 to be accessible by any child views.
*/
@main
struct iScheduleApp: App {
    
    /**
    The persistent container from the shared `CoreDataManager`.
    This is responsible for loading and saving data to the app's CoreData store.
    */
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    /**
    The main content of the app.
    
    This constructs the `MainTabView` and provides it with the necessary environment context
    for accessing and manipulating CoreData entities.
    */
    var body: some Scene {
        WindowGroup {
            MainTabView().environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}

