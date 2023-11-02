//
//  AppDelegate.swift
//  Snapgram
//
//  Created by Phincon on 02/11/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Set the default navigation bar background color to white
            UINavigationBar.appearance().barTintColor = .white

            // Observe changes in the shared data source
            NotificationCenter.default.addObserver(self, selector: #selector(updateNavBarBackgroundColor), name: NSNotification.Name("TableViewDidScroll"), object: nil)

        return true
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
    
    @objc func updateNavBarBackgroundColor() {
          // Check the table view offset from the shared data source
          if SharedDataSource.shared.tableViewOffset > 100 { // Adjust the threshold as needed
              UINavigationBar.appearance().barTintColor = .white
          } else {
              UINavigationBar.appearance().barTintColor = .clear
          }
      }

}

