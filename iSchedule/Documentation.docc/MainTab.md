# Getting started with iSchedule

Helping you with the basics

## Initialization
Starting with iSchedule involves leveraging the app's ``MainTabView`` as the initial view to provide a structured and navigable user interface. Here, each tab redirects to a distinct functionality within the app, facilitating easy transitions between task viewing, creation, and statistics analysis. For more information about the views click on the view's link.
```swift
@main
struct iScheduleApp: App {
    let context = PersistenceController.shared.container.viewContext
    
    var body: some Scene {
        WindowGroup {
            MainTabView().environment(\.managedObjectContext, context)
        }
    }
}
```

## Navigating with MainTab
Through the MainTabView, users can navigate between two principal sections of the application: ``ListView`` and ``StatisticView``, enabled by the embedded ``CustomTabBar`` situated at the bottom of the screen.
![MainTabView](MainTab_1.png)
![MainTabView](Statistic_1.png)


## Creating and Managing Lists
Using ``AddListView`` (click on the 'Add List' in MainTabView), users can create a new `TaskList` entity, entering details like the list’s name and choosing a color for easy identification and aesthetic appeal. By clicking on the gearshape symbol, users are directed to the ``ListSettingsView`` able to edit and change the list's details.
![AddListView](AddList_1.png)
![MainTabView](MainTab_2.png)

## Viewing and Managing Tasks
After creating a list, by clicking on the selected list, you now can create new tasks on the list. ``TaskView`` and ``AddTaskView`` ensure efficient management and addition of tasks, respectively. By clicking on the gearshape symbol, users are directed to the ``TaskSettingsView`` where they are able to edit and change the task's details.
![TaskView](TaskView_1.png)
![AddTaskView](AddTask_1.png)
![TaskView](TaskView_2.png)

## Tracking Your Stats
``StatisticView`` delivers a visual representation and summary of all your lists and tasks, using pie charts and motivational quotes to keep you inspired and informed about your progress and workload.

![MainTabView](Statistic_2.png)
