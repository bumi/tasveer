//
//  AuthManager.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/15/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    
    static private let UserDefaultsIdentifierKey = "UserDefaultsIdentifierKey"
    static private let UserDefaultsEmailKey = "UserDefaultsEmailKey"
    static private let UserDefaultsNameKey = "UserDefaultsNameKey"
    
    private let ud = UserDefaults.standard
    
    private init() {}
    
    func authorizeIfNeeded(completionHandler: @escaping () -> Void) {
        
    }
    
    func saveUser(user: UserResponse) {
        ud.set(user.identifier, forKey: AuthManager.UserDefaultsIdentifierKey)
        ud.set(user.email, forKey: AuthManager.UserDefaultsEmailKey)
        ud.set(user.name, forKey: AuthManager.UserDefaultsNameKey)
        ud.synchronize()
    }
}
