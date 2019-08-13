//
//  AppManager.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class AppManager {
    static let shared = AppManager()
    
    private let queue = OperationQueue()
    
    private init() {}
    
    func showInitialScene() {
        let operation = ShowMainSceneOperation()
        queue.addOperation(operation)
    }
    
    func showMainScene() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return }
        
        // Load persistent store first and then show main scene of the app
        PersistentStoreManager.shared.createMoodyContainer { [weak self, weak appDelegate] (_) in
            let vc = UIStoryboard.init(name: "Collections", bundle: Bundle.main).instantiateInitialViewController()
            self?.replace(viewController: vc, inWindow: appDelegate?.window)
        }
    }
    
    // Accept invite
    func launchedFromUniversalLink(inviteId: String, collectionId: String) {
        let showInvite = ShowInviteSceneOperation(forCollectionId: collectionId, inviteId: inviteId)
        queue.addOperation(showInvite)
    }
    
    private func replace(viewController vc: UIViewController?, inWindow window: UIWindow?) {
        UIView.transition(with: window!, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            DispatchQueue.main.async {
                window?.rootViewController = vc
            }
        }, completion: nil)
    }
}
