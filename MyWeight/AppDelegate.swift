//
//  AppDelegate.swift
//  MyWeight
//
//  Created by Diogo Tridapalli on 3/29/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit
import HealthKit

typealias Dict = [UIApplicationLaunchOptionsKey: Any]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var coordinator: AppCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: Dict?) -> Bool
    {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let navigationController = UINavigationController()
        window.rootViewController = navigationController

        let coordinator = AppCoordinator(with: navigationController)
        self.coordinator = coordinator

        coordinator.start()

        window.makeKeyAndVisible()

        return true
    }

    // TODO: extract this to AppCoordinator 
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        let healthStore = HKHealthStore()
        healthStore.handleAuthorizationForExtension { (success, error) in
            print("\(success), \(error)")
        }
    }

}
