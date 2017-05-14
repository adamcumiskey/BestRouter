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
    var router: Router!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        self.router = SplitRouter(
            title: "BestRouter", 
            master: TabRouter(
                title: "TabRouter",
                routers: [
                    StackRouter(
                        title: "A",
                        root: Router(title: "A") {
                            let vc = UIViewController()
                            vc.view.backgroundColor = .green
                            vc.title = "A"
                            vc.tabBarItem = UITabBarItem(title: "A", image: nil, tag: 0)
                            return vc
                        }
                    ),
                    StackRouter(
                        title: "C",
                        root: Router(title: "C") {
                            let vc = UIViewController()
                            vc.view.backgroundColor = .orange
                            vc.title = "C"
                            vc.tabBarItem = UITabBarItem(title: "C", image: nil, tag: 1)
                            return vc
                        }
                    )
                ]
            ),
            detail: StackRouter(
                title: "Stack",
                root: Router(title: "Detail") {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .blue
                    vc.title = "B"
                    return vc
                }
            )
        )
        
        self.window = UIWindow()
        window!.frame = UIScreen.main.bounds
        window!.attach(router: self.router)
        
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

