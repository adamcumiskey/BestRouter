//
//  AppDelegate.swift
//  BestRouter
//
//  Created by Adam Cumiskey on 01/15/2017.
//  Copyright (c) 2017 Adam Cumiskey. All rights reserved.
//

import UIKit
import BestRouter


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // anchor for the router hierarchy
    var router: Any!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let blueVC = UIViewController()
        blueVC.view.backgroundColor = .blue
        blueVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        let redVC = UIViewController()
        redVC.view.backgroundColor = .red
        redVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        
        let yellowVC = UIViewController()
        yellowVC.view.backgroundColor = .yellow
        
        let vcRouter1 = Router(viewController: blueVC)
        let vcRouter2 = Router(viewController: redVC)
        let vcRouter3 = Router(viewController: yellowVC)
        
        let nav1 = NavigationRouter(root: vcRouter1)
        let nav2 = NavigationRouter(root: vcRouter2)
        let nav3 = NavigationRouter(root: vcRouter3)
        
        let tab = TabBarRouter(items: [nav1, nav2])
        let split = SplitViewRouter(master: nav3, detail: tab)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad
            let router = WindowRouter(root: split, window: window)
            router.launch()
            self.router = router
        } else {
            // iPhone
            let router = WindowRouter(root: tab, window: window)
            router.launch()
            self.router = router
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

