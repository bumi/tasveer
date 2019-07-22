//
//  InviteViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/22/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class InviteViewController: UIViewController {
    private let queue = OperationQueue()
    
    @IBOutlet fileprivate weak var name: UILabel!
    @IBOutlet fileprivate weak var photoNumber: UILabel!
    @IBOutlet fileprivate weak var users: UILabel!
    
    @IBAction fileprivate func acceptInvite() {
        
    }
    
    @IBAction fileprivate func cancelInvite() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
