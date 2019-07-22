//
//  ShowInviteSceneOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/23/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class ShowInviteSceneOperation: Operation {
    private var vc: InviteViewController?
    
    private let collectionId: String
    private let inviteId: String
    
    init(forCollectionId collectionId: String, inviteId: String) {
        self.collectionId = collectionId
        self.inviteId = inviteId
        
        super.init()
        
        name = "Show Invite Scene Operation"
    }
    
    override func execute() {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
                else { return }
            
            self.vc = UIStoryboard.init(name: "Invite", bundle: Bundle.main).instantiateInitialViewController() as? InviteViewController
            self.vc?.delegate = self
            self.vc?.collectionId = self.collectionId
            self.vc?.inviteId = self.inviteId
            
            appDelegate.window?.rootViewController = self.vc
        }
    }
}

extension ShowInviteSceneOperation: InviteViewControllerDelegate {
    func shouldDismiss() {
        DispatchQueue.main.async {
            self.vc?.dismiss(animated: true, completion: nil)
        }
    }
}
