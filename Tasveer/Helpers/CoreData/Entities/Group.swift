//
//  Group.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import CoreData

final class Group: NSManagedObject {
    @NSManaged fileprivate(set) var identifier: String
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var createdAt: Date
    
    @NSManaged fileprivate(set) var users: Set<User>
    @NSManaged fileprivate(set) var filter: Filter
}

extension Group: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(createdAt), ascending: false)]
    }
    
    static func filter(query q: String) -> NSPredicate {
        return NSPredicate(format: "name contains[c] %@", q)
    }
}

extension Group {
    @discardableResult
    static func insertNew(into moc: NSManagedObjectContext, fromCollection collection: GroupResponse) -> Group {
        let newGroup: Group = moc.insertObject()
        newGroup.identifier = collection.identifier
        newGroup.name = collection.name
        newGroup.createdAt = Date()
        
        newGroup.users = User.insertNewUsers(into: moc, users: collection.users)
        
        return newGroup
    }
}
