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
    
    var isAuthorized: Bool {
        guard let _ = ud.value(forKey: AuthManager.UserDefaultsIdentifierKey)
            else { return false }
        
        return true
    }
    
    var token: String? {
        return ud.string(forKey: AuthManager.UserDefaultsIdentifierKey)
    }
    
    private let ud = UserDefaults.standard
    
    private init() {}
    
    func saveUser(user: UserResponse) {
        ud.set(user.identifier, forKey: AuthManager.UserDefaultsIdentifierKey)
        ud.set(user.email, forKey: AuthManager.UserDefaultsEmailKey)
        ud.set(user.name, forKey: AuthManager.UserDefaultsNameKey)
        ud.synchronize()
    }
}
