//
//  AppDelegate.swift
//  Ultracorps Battle Simulator 1
//
//  Created by Darrell Root on 5/17/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var managedContext: NSManagedObjectContext!
    var debug = true
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        managedContext = persistentContainer.viewContext
        readData()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveData()
        saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveData()
        saveContext()
    }
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        saveData()
        saveContext()
    }

    /* Functions moved to fleets.swift in global scope.  Yes I'm a bad programmer
     func saveData() {
        deleteAllCoreData()
        if debug { print("saveData")}
        let FleetEntity = NSEntityDescription.entity(forEntityName: "CoreDataFleet", in: managedContext)!
        let TaskForceEntity = NSEntityDescription.entity(forEntityName: "CoreDataTaskForce", in: managedContext)!
        for fleet in fleets {
            let newFleet = CoreDataFleet(entity: FleetEntity, insertInto: managedContext)
            newFleet.name = fleet.name
            for loop in 0..<units.count {
                if fleet.quantities[loop] > 0 {
                    let newTaskForce = CoreDataTaskForce(entity: TaskForceEntity, insertInto: managedContext)
                    newTaskForce.unitIndex = Int64(loop)
                    newTaskForce.quantities = Int64(fleet.quantities[loop])
                    newFleet.addToMember(newTaskForce)
                }
            }
        }
    }*/
    func readData() {
        if debug {print("readData")}
        let request = NSFetchRequest<CoreDataFleet>(entityName: "CoreDataFleet")
        if let coreDataFleets = try? managedContext.fetch(request) {
            for coreDataFleet in coreDataFleets {
                var newFleet = fleet()
                if let fleetName = coreDataFleet.name {
                    newFleet.name = fleetName
                } else {
                    newFleet.name = "Unnamed Fleet"
                }
                print("Fleet \(String(describing: coreDataFleet.name))")
                if let coreDataTaskForces = coreDataFleet.member?.allObjects as! [CoreDataTaskForce]? {
                    for coreDataTaskForce in coreDataTaskForces {
                        newFleet.quantities[Int(coreDataTaskForce.unitIndex)] = Int(coreDataTaskForce.quantities)
                        print("TaskForce \(coreDataTaskForce.unitIndex) \(coreDataTaskForce.quantities)")
                    }
                }
                fleets.append(newFleet)
            }
        } else {
            print("failed to fetch")
        }
    }
    /*func deleteAllCoreData() {
        if debug { print("deleteAllCoreData")}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataFleet")
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                managedContext.delete(managedObject as! NSManagedObject)
            }
        } catch let error as NSError {
            print("Delete all data error \(error) \(error.userInfo)")
        }
    }*/
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

