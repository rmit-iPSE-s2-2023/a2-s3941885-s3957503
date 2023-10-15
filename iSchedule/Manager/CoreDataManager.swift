import Foundation
import CoreData
/**
 `CoreDataManager` is a singleton class designed to manage the interaction between the application and its underlying Core Data persistent storage. It initializes and manages an `NSPersistentContainer` for the data model named `iScheduleModel`.

 ### Overview:
 - Singleton Design Pattern: Ensures that a single instance of the `CoreDataManager` manages all interactions throughout the app's lifecycle.
 - Initialization: The `NSPersistentContainer` is initialized and set up for the data model named `iScheduleModel`. Errors during this process will result in a runtime crash.

 ### Data Model: `iScheduleModel`
 The `iScheduleModel` includes two primary entities:
 1. **TaskList**
 2. **Task**

 #### 1. TaskList:
 Represents a collection of tasks.

 - **Attributes:**
    - `colorString: String`: Color associated with the task list.
    - `iconName: String`: Name of the icon associated with the task list.
    - `id: UUID`: Unique identifier for each task list.
    - `name: String`: Name/title of the task list.

 - **Relationships:**
    - **Tasks**: One-to-many relationship with `Task`. Deleting a `TaskList` will cascade and delete all associated tasks.

 #### 2. Task:
 Represents an individual task item.

 - **Attributes:**
    - `alertOption: String`: Configuration for alert notifications.
    - `dueDate: Date`: Date on which the task is due.
    - `dueTime: Date`: Specific time of the day when the task is due.
    - `priority: Date`: Priority level of the task.
    - `status: Date`: Current status of the task (e.g., pending, completed).
    - `taskDescription: String`: Detailed description of the task.
    - `title: String`: Name or title of the task.

 - **Relationships:**
    - **TaskList**: Associated with a single `TaskList`. Deleting a `Task` nullifies its association with the `TaskList`, but the `TaskList` remains intact.

 ### Notes:
 - Handle Core Data operations, like saving to the context or fetching, with care, ensuring that errors are managed.
 - Understanding the relationships and their delete rules is vital to avoid unintentional data deletions or inconsistencies.
 */

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    private init() {
        
        persistentContainer = NSPersistentContainer(name:"iScheduleModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
        
    }
    
}
