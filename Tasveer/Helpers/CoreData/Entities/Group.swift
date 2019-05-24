//
//  Group.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import CoreData

enum GroupSyncState: String {
    case none
    case syncing
    case synced
}

final class Group: NSManagedObject {
    @NSManaged fileprivate(set) var identifier: String
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var descr: String?
    @NSManaged fileprivate(set) var createdAt: Date
    @NSManaged fileprivate(set) var syncState: String
    @NSManaged fileprivate(set) var uploadProgress: Float
    
    @NSManaged fileprivate(set) var photos: Set<Photo>?
    @NSManaged fileprivate(set) var users: Set<User>
    @NSManaged fileprivate(set) var filter: Filter
    @NSManaged fileprivate(set) var task: UploadTask?
    
    var syncStateValue: GroupSyncState {
        get {
            guard let c = GroupSyncState(rawValue: syncState) else { fatalError("Unknown state") }
            return c
        }
        
        set {
            syncState = newValue.rawValue
        }
    }
    
    /// Total amount of all observable tasks which counts in total progress
    var totalUnitsToBeUploaded: Int64 {
        var totalUnits: Int64 = 0
        
        if let photos = photos, !photos.isEmpty {
            // Add the amount of photos that needs to be uploaded
            totalUnits += totalPhotosToBeUploaded
        }
        
        return totalUnits
    }
    
    /// Total units of images to be uploaded
    var totalPhotosToBeUploaded: Int64 {
        return Int64(task?.assets?.count ?? 0)
    }
    
    /// Total units of images not have been uploaded from current task
    var unfinishedPhotoUploads: Int64 {
        let total = task?.assets?
            .filter{ !$0.isUploaded }
            .count ?? 0
        return Int64(total)
    }
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
    static func insertNew(into moc: NSManagedObjectContext, fromCollection collection: CollectionResponse, filter: FiltersModel?) -> Group {
        let newGroup: Group = moc.insertObject()
        newGroup.identifier = collection.identifier
        newGroup.name = collection.name
        newGroup.descr = collection.description
        newGroup.createdAt = Date()
        newGroup.syncStateValue = .none
        
        newGroup.users = User.insertNewUsers(into: moc, users: collection.users)
        
        if let filter = filter {
            newGroup.filter = Filter.insertNewFilter(into: moc, fromFilterModel: filter)
        } else {
            newGroup.filter = Filter.insertNewFilter(into: moc)
        }
        
        return newGroup
    }
    
    // Save state of upload when app is terminated
    func saveState() {
        task?.pause()
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
    
    // Remove all localPhotos
    func preFilterCleanup(forMoc moc: NSManagedObjectContext?) {
        let cleanupPhotos = Array(photos ?? [])
            .filter({ $0.typeValue == .local && $0.statusValue == .none })
        
        for cleanupPhoto in cleanupPhotos {
            moc?.delete(cleanupPhoto)
        }
    }
    
    // Update the progress of the Group while syncing
    func updateProgress(value: Float) {
        uploadProgress = value
    }
}
