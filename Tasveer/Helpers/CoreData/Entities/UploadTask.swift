//
//  UploadTask.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/20/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import CoreData

final class UploadTask: NSManagedObject {
    @NSManaged fileprivate(set) var isPaused: Bool
    
    @NSManaged fileprivate(set) var group: Group
    @NSManaged fileprivate(set) var assets: Set<UploadAsset>?
}

extension UploadTask: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}

extension UploadTask {
    static func insertNewTask(into moc: NSManagedObjectContext, for group: Group) -> UploadTask {
        let newTask: UploadTask = moc.insertObject()
        newTask.isPaused = false
        newTask.group = group
        
        newTask.assets = Set()
        if let assets = group.photos?
            .compactMap({ $0 })
            .filter({ $0.assetIdentifier != nil }) {
            for asset in assets {
                let uploadAsset = UploadAsset.insertNewAsset(into: moc, with: asset.assetIdentifier!)
                newTask.assets?.insert(uploadAsset)
            }
        }
        
        return newTask
    }
}
