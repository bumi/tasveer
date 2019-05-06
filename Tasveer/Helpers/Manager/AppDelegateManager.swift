//
//  AppDelegateManager.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class AppDelegateManager {
    private static var root: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    static var currentViewController: UIViewController? {
        let root = AppDelegateManager.root
        if root is UINavigationController {
            return (root as? UINavigationController)?.viewControllers.first
        }
        
        return root
    }
    
    static var currentNavigationController: UINavigationController? {
        let root = AppDelegateManager.root
        if root is UINavigationController {
            return root as? UINavigationController
        }
        
        return nil
    }
    
    static var lastTopViewController: UIViewController? {
        var vc = AppDelegateManager.root
        
        while let presented = vc?.presentedViewController {
            vc = presented
        }
        
        return vc
    }
}
