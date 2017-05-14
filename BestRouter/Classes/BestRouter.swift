//
//  BestRouter.swift
//  Pods
//
//  Created by Adam Cumiskey on 1/15/17.
//
//

import UIKit

/// Generic Router base class
public class Router: Equatable {
    typealias Constructor = (Router) -> UIViewController
    
    public var title: String
    fileprivate var identifier: String
    public weak var viewController: UIViewController?
    private var constructViewControllerBlock: Constructor
    
    public init<ViewController: UIViewController>(
        title: String,
        identifier: String = UUID().uuidString,
        constructor: @escaping (Router) -> ViewController
    ) {
        self.title = title
        self.identifier = identifier
        self.constructViewControllerBlock = constructor
    }
    
    public func createViewController() -> UIViewController {
        let vc = constructViewControllerBlock(self)
        self.viewController = vc
        return vc
    }
}

public func ==(left: Router, right: Router) -> Bool {
    return left.identifier == right.identifier
}

/// Router wrapping UINavigationController
public class StackRouter: Router {
    public var root: Router
    private var delegate: UINavigationControllerDelegate?
    
    public required init(
        title: String, 
        root: Router, 
        delegate: UINavigationControllerDelegate? = nil, 
        constructor: @escaping () -> UINavigationController = UINavigationController.init
    ) {
        self.root = root
        self.delegate = delegate
        super.init(title: title, constructor: { _ in
            let navigationController = constructor()
            navigationController.viewControllers = [root.createViewController()]
            navigationController.delegate = delegate
            return navigationController
        })
    }
}


/// Router wrapping UITabBarController
public class TabRouter: Router {
    public let routers: [Router]
    private var delegate: UITabBarControllerDelegate?
    
    public init(
        title: String, 
        routers: [Router], 
        delegate: UITabBarControllerDelegate? = nil, 
        constructor: @escaping () -> UITabBarController = UITabBarController.init
    ) {
        self.routers = routers
        self.delegate = delegate
        
        super.init(title: title) { _ in
            let tabBar = constructor()
            tabBar.viewControllers = routers.map { $0.createViewController() }
            tabBar.delegate = delegate
            return tabBar
        }
    }
}


/// Router wrapping UISplitViewController
public class SplitRouter: Router {
    public let master: Router
    public let detail: Router
    private var delegate: UISplitViewControllerDelegate?
    
    public init(
        title: String,
        master: Router,
        detail: Router, 
        delegate: UISplitViewControllerDelegate? = nil,
        constructor: @escaping () -> UISplitViewController = UISplitViewController.init
    ) {
        self.master = master
        self.detail = detail
        self.delegate = delegate
        
        super.init(title: title) { _ in
            let splitViewController = constructor()
            splitViewController.viewControllers = [
                master.createViewController(),
                detail.createViewController()
            ]
            splitViewController.delegate = delegate
            return splitViewController
        }
    }
}


extension UIWindow {
    public func attach(router: Router) {
        rootViewController = router.createViewController()
        makeKeyAndVisible()
    }
    
    private func setRootViewController(_ viewController: UIViewController, animated: Bool = true, completion: ((Void) -> Void)? = nil) {
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
