//
//  AppDelegate.swift
//  MyWeight
//
//  Created by Diogo Tridapalli on 3/29/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit
import HealthKit

typealias Dict = [UIApplication.LaunchOptionsKey: Any]

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

    // Health access in extensions

    func applicationShouldRequestHealthAuthorization(_ application: UIApplication)
    {
        coordinator?.extensionRequestedAuthorization()
    }

    // Handoff

    func application(_ application: UIApplication,
                     willContinueUserActivityWithType userActivityType: String) -> Bool
    {
        Log.debug(userActivityType)
        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        Log.debug(userActivity.activityType)
        return true
    }

}
