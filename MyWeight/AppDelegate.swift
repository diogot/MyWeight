//
//  AppDelegate.swift
//  MyWeight
//
//  Created by Diogo Tridapalli on 3/29/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        window.rootViewController = UINavigationController(rootViewController: ListViewController())
        window.makeKeyAndVisible()
        
        return true
    }

}
