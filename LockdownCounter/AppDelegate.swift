//
//  AppDelegate.swift
//  LockdownCounter
//
//  Created by Samuel Miller on 30/03/2020.
//  Copyright © 2020 RHM Computing. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: - Date calculating
        let isoDate = "2020-03-23T00:00:00+0000"

        let dateFormatter = ISO8601DateFormatter()
        let startDate = dateFormatter.date(from:isoDate)!
        let currentDate = Date()
        let secondsSince = currentDate.timeIntervalSince(startDate)
        
        GlobalData.Data.days = Int(floor(secondsSince / 60 / 60 / 24))
        
        // MARK: - First launch set up stuff
        
        let center = UNUserNotificationCenter.current()
        
        if UserDefaults.standard.bool(forKey: "notFirstLaunch?") {
            // NOT FIRST LAUNCH
        } else {
            // FIRST LAUNCH
            UserDefaults.standard.setValue(true, forKeyPath: "notFirstLaunch?")
           /*
            let group = DispatchGroup()
            group.enter()
            
            DispatchQueue.main.async {
                locationManager.requestWhenInUseAuthorization()
                group.leave()
            }
            
            group.notify(queue: .main) {
                UserDefaults.standard.setValue(locationManager.location?.coordinate,
                                               forKeyPath: "homeCoords")
            }
            
            */
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in   // request notification auth
                // Enable or disable features based on authorization.
                if (granted) {
                    UserDefaults.standard.set(true, forKey: "notificationsAllowed")
                } else {
                    UserDefaults.standard.set(false, forKey: "notificationsAllowed")
                }
            }
            
        }
        
        return true
    }
    
    

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "LockdownCounter")
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

