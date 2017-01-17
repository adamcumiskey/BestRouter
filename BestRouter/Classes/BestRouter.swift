//
//  BestRouter.swift
//  Pods
//
//  Created by Adam Cumiskey on 1/15/17.
//
//

import UIKit


public protocol RouterType: class {
    var viewController: UIViewController { get }
}

public protocol ParentRouterType: RouterType {
    func attatch(router: RouterType, animated: Bool)
    func detatch(router: RouterType, animated: Bool)
}


/// Generic Router base class
public class Router<ViewController: UIViewController>: RouterType {
    fileprivate var _viewController: ViewController
    public var viewController: UIViewController { return _viewController }
    
    public init(viewController: ViewController) {
        _viewController = viewController
    }
}


/// Base of the Router heirarchy in a window
/// You should create and retain this in your App Delegate when `applicationDidFinishLaunching` is called
public final class WindowRouter<Router: RouterType>: RouterType {
    public var root: Router
    public var viewController: UIViewController { return root.viewController }
    
    private var window: UIWindow
    
    public init(root: Router, window: UIWindow) {
        root.viewController.view.frame = window.bounds
        self.root = root
        self.window = window
    }
    
    public func launch() {
        window.rootViewController = root.viewController
        window.makeKeyAndVisible()
    }
}


/// Router wrapping UINavigationController
public class NavigationRouter<Root: RouterType>: Router<UINavigationController>, ParentRouterType {
    public var root: Root
    private var delegate: UINavigationControllerDelegate?
    
    public init(root: Root, delegate: UINavigationControllerDelegate? = nil) {
        self.root = root
        
        let navigationController = UINavigationController(rootViewController: root.viewController)
        navigationController.delegate = delegate
        super.init(viewController: navigationController)
    }
    
    public func attatch(router: RouterType, animated: Bool = true) {
        self._viewController.pushViewController(router.viewController, animated: animated)
    }
    
    public func detatch(router: RouterType, animated: Bool = true) {
        self._viewController.popViewController(animated: animated)
    }
}


/// Router wrapping UITabBarController
public class TabBarRouter: Router<UITabBarController> {
    public var items: [RouterType]
    private var delegate: UITabBarControllerDelegate?
    
    public init(items: [RouterType], delegate: UITabBarControllerDelegate? = nil) {
        self.items = items
        self.delegate = delegate
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = self.items.map { $0.viewController }
        tabBar.delegate = delegate
        super.init(viewController: tabBar)
    }
}


/// Router wrapping UISplitViewController
public class SplitViewRouter<Master: RouterType, Detail: RouterType>: Router<UISplitViewController> {
    public var master: Master
    public var detail: Detail
    private var delegate: UISplitViewControllerDelegate?
    
    public init(master: Master, detail: Detail, delegate: UISplitViewControllerDelegate? = nil) {
        self.master = master
        self.detail = detail
        self.delegate = delegate
        
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [master.viewController, detail.viewController]
        splitViewController.delegate = delegate
        
        super.init(viewController: splitViewController)
    }
}
