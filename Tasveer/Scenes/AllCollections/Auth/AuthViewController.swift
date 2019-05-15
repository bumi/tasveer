//
//  AuthViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/15/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

protocol AuthViewControllerDelegate: class {
    func didLogin()
}

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    
    private let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let operation = AuthOperation(withEmail: nil, andName: nil)
        operation.addCompletionBlock { [weak self] in
            self?.delegate?.didLogin()
        }
        
        queue.addOperation(operation)
    }
}
