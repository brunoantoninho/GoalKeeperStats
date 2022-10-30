//
//  AppDelegate.swift
//  GoalKeeperStats
//
//  Created by Bruno Antoninho on 30/10/2022.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyBeaver
import RealmSwift

let log = SwiftyBeaver.self

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        log.addDestination(ConsoleDestination())
        configureRealm()
        
        return true
    }
    
    private func configureRealm() {
        let currentSchemaVersion: UInt64 = 1

        let config = Realm.Configuration(
            schemaVersion: currentSchemaVersion,

            migrationBlock: { _, oldSchemaVersion in
                switch oldSchemaVersion {
                    // add cases as the schema gets bumped and migrations are needed
                default:
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                    break
                }
            }
        )

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // NOTE: this should never be pushed in an uncommented state, it is just for debugging/development purposes.
         Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
    }

    // MARK: UISceneSession Lifecycle

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
}

