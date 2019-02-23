//
//  AppDelegate.swift
//  Todoey
//
//  Created by Pranav Sharma on 13/02/19.
//  Copyright © 2019 Pranav Sharma. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    print("Migration in progress")
                    migration.enumerateObjects(ofType: Item.className(), { (oldObject, newObject) in
                        var dateComponents = DateComponents()
                        dateComponents.year = 2019
                        dateComponents.month = 1
                        dateComponents.day = 1
                        newObject!["dateCreated"] = NSCalendar.current.date(from: dateComponents)!
                    })
                }
                
        })
        
        Realm.Configuration.defaultConfiguration = config
        
        do {
            _ = try Realm()
        } catch {
            print("Unable to initialise Realm \(error)")
        }
        
        return true
    }

}

