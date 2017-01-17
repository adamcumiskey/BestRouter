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


/// Base of the Router heirarchy in a window
/// You should create and retain this in your App Delegate when `applicationDidFinishLaunching` is called
public final class WindowRouter: RouterType {
    public var viewController: UIViewController { return root.viewController }
    public var root: RouterType {
        didSet {
            window.setRootViewController(root.viewController)
        }
    }
    
    private var window: UIWindow
    
    public init(root: RouterType, window: UIWindow) {
        root.viewController.view.frame = window.bounds
        self.root = root
        self.window = window
    }
    
    public func launch() {
        window.rootViewController = root.viewController
        window.makeKeyAndVisible()
    }
}

extension UIWindow {
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true, completion: ((Void) -> Void)? = nil) {
        viewController.view.frame = frame
        if animated == true {
            UIView.transition(
                with: self,
                duration: 0.23,
                options: [.allowAnimatedContent, .transitionCrossDissolve],
                animations: {
                    self.rootViewController = viewController
            },
                completion: { done in
                    if let completion = completion {
                        completion()
                    }
            }
            )
        } else {
            rootViewController = viewController
            if let completion = completion {
                completion()
            }
        }
    }
}
