//
//  ShopMainSceneOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/15/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class ShowMainSceneOperation: Operation {
    
    override func execute() {
        if AuthManager.shared.isAuthorized {
            showMainScene()
        } else {
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    else { return }
                
                let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateInitialViewController() as? AuthViewController
                vc?.delegate = self
                appDelegate.window?.rootViewController = vc
            }
        }
    }
    
    private func showMainScene() {
        DispatchQueue.main.sync {
            AppManager.shared.showMainScene()
        }
        
        finish()
    }
}

extension ShowMainSceneOperation: AuthViewControllerDelegate {
    func didLogin() {
        showMainScene()
    }
}
