//
//  InviteViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/22/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol InviteViewControllerDelegate: class {
    func shouldDismiss()
}

final class InviteViewController: UITableViewController {
    var collectionId: String?
    var inviteId: String?
    
    weak var delegate: InviteViewControllerDelegate?
    
    private var collectionResponse: CollectionResponse?
    private let queue = OperationQueue()
    
    @IBOutlet fileprivate weak var name: UILabel!
    @IBOutlet fileprivate weak var photoNumber: UILabel!
    @IBOutlet fileprivate weak var users: UILabel!
    @IBOutlet fileprivate weak var acceptButton: UIButton!
    @IBOutlet fileprivate weak var cancelButton: UIBarButtonItem!
    
    @IBAction fileprivate func acceptInvite() {
        if let inviteId = inviteId, let collectionResponse = collectionResponse {
            cancelButton.isEnabled = false // So user can't cancel while invite is being accepted
            MBProgressHUD.showAdded(to: view, animated: true)
            
            let acceptOperation = AcceptInviteSaveCollectionOperation(forCollectionResponse: collectionResponse, inviteId: inviteId)
            acceptOperation.addCompletionBlock { [unowned self] in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.cancelInvite()
                }
            }
            queue.addOperation(acceptOperation)
        }
    }
    
    @IBAction fileprivate func cancelInvite() {
        delegate?.shouldDismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionId = collectionId {
            MBProgressHUD.showAdded(to: view, animated: true)
            
            let fetchOperation = FetchCollectionByIdOperation(forCollectionId: collectionId) { [unowned self] (resp) in
                DispatchQueue.main.async {
                    self.collectionResponse = resp
                    self.updateLayout(from: resp)
                }
            }
            
            fetchOperation.addCompletionBlock { [unowned self] in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            
            queue.addOperation(fetchOperation)
        }
    }
    
    private func updateLayout(from resp: CollectionResponse) {
        name.text = resp.name
        photoNumber.text = "\(resp.photos.count) photos"
        users.text = resp.users.map({$0.email ?? ""}).joined(separator: ", ")
        acceptButton.isEnabled = true
    }
}
