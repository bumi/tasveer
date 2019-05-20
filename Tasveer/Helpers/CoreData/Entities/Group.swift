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
    @NSManaged fileprivate(set) var descr: String?
    @NSManaged fileprivate(set) var createdAt: Date
    
    @NSManaged fileprivate(set) var photos: Set<Photo>?
    @NSManaged fileprivate(set) var users: Set<User>
    @NSManaged fileprivate(set) var filter: Filter
    @NSManaged fileprivate(set) var task: UploadTask?
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
    static func insertNew(into moc: NSManagedObjectContext, fromCollection collection: CollectionResponse) -> Group {
        let newGroup: Group = moc.insertObject()
        newGroup.identifier = collection.identifier
        newGroup.name = collection.name
        newGroup.descr = collection.description
        newGroup.createdAt = Date()
        
        newGroup.users = User.insertNewUsers(into: moc, users: collection.users)
        newGroup.filter = Filter.insertNewFilter(into: moc)
        
        return newGroup
    }
    
    static func insertNew(into moc: NSManagedObjectContext) -> Group {
        let newGroup: Group = moc.insertObject()
        newGroup.identifier = ""
        newGroup.name = ""
        newGroup.descr = nil
        newGroup.createdAt = Date()
        
        newGroup.users = Set<User>()
        newGroup.filter = Filter.insertNewFilter(into: moc)
        
        return newGroup
    }
    
    // Create new task for upload
    func newTask(fromMoc moc: NSManagedObjectContext) {
        task = UploadTask.insertNewTask(into: moc, for: self)
    }
    
    // Remove current task for upload
    func removeTask(forMoc moc: NSManagedObjectContext?) {
        if let task = task {
            moc?.delete(task)
        }
    }
}
