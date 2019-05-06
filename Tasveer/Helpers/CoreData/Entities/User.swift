//
//  User.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import CoreData

final class User: NSManagedObject {
    @NSManaged fileprivate(set) var name: String?
    @NSManaged fileprivate(set) var email: String?
    @NSManaged fileprivate(set) var deviceId: String
    @NSManaged fileprivate(set) var identifier: String
    
    @NSManaged fileprivate(set) var group: Group
}

extension User: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}

extension User {
    static func insertNewUsers(into moc: NSManagedObjectContext, users: [UserResponse]) -> Set<User> {
        var newUsers: Set<User> = []
        
        for user in users {
            let newUser: User = moc.insertObject()
            newUser.name = user.name
            newUser.email = user.email
            newUser.deviceId = user.deviceId
            newUser.identifier = user.identifier
            
            newUsers.insert(newUser)
        }
        
        return newUsers
    }
}
