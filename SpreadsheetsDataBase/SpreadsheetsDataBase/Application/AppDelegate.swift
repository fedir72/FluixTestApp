//
//  AppDelegate.swift
//  SpreadsheetsDataBase
//
//  Created by Fedii Ihor on 18.06.2022.
//

import UIKit

//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navController = UINavigationController()
        coordinator = AppCoordinator(navController)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

      
        return true
    }

    // MARK: UISceneSession Lifecycle

  

}

