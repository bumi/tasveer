//
//  AuthOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/15/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import Alamofire

final class AuthOperation: Operation {
    let email: String?
    let username: String?
    
    private var deviceId: String {
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString
            else { fatalError("No Device ID") }
        return deviceID
    }
    
    init(withEmail email: String?, andName username: String?) {
        self.email = email
        self.username = username
        super.init()
        
        name = "Authorization Operation"
    }
    
    override func execute() {
        API.signUp(fetchParameters()).responseParsed { [weak self] (res: Swift.Result<UserResponse, ResponseError>) in
            switch res {
            case .success(let user):
                AuthManager.shared.saveUser(user: user)
                self?.finish()
            case .failure(let error):
                debugPrint(error.localizedDescription)
                // If 422 -> device_id has already taken
                if error.statusCode == 422 {
                    self?.fetchExistingUser()
                } else {
                    self?.finishWithError(NSError.init(code: .conditionFailed))
                }
            }
        }
    }
    
    private func fetchExistingUser() {
        API.signIn(deviceId: deviceId, fetchParameters()).responseParsed { [weak self] (res: Swift.Result<UserResponse, ResponseError>) in
            switch res {
            case .success(let user):
                AuthManager.shared.saveUser(user: user)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
            
            self?.finish()
        }
    }
    
    private func fetchParameters() -> Parameters {
        var params: Parameters = [
            "device_id": deviceId
        ]
        
        if let email = email {
            params["email"] = email
        }
        
        if let username = username {
            params["username"] = username
        }
        
        return params
    }
}
