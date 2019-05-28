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
    
    @NSManaged fileprivate(set) var collection: Collection
    @NSManaged fileprivate(set) var assets: Set<UploadAsset>?
}

extension UploadTask: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}

extension UploadTask {
    static func insertNewTask(into moc: NSManagedObjectContext, for collection: Collection) -> UploadTask {
        let newTask: UploadTask = moc.insertObject()
        newTask.isPaused = false
        newTask.collection = collection
        
        newTask.assets = Set()
        if let assets = collection.photos?
            .compactMap({ $0 })
            .filter({ $0.assetIdentifier != nil }) {
            for asset in assets {
                let uploadAsset = UploadAsset.insertNewAsset(into: moc, with: asset.assetIdentifier!)
                newTask.assets?.insert(uploadAsset)
            }
        }
        
        return newTask
    }
    
    func  updateTask(assetUploaded assetIdentifier: String?) {
        if let  assetIdentifier =  assetIdentifier {
            for asset in assets ?? [] where asset.assetIdentifier ==  assetIdentifier {
                asset.updateIsUploaded(true)
            }
        }
    }
    
    // Pause the task
    func pause() {
        self.isPaused = true
    }
    
    // Resume the task
    func resume() {
        self.isPaused = false
    }
    
    // Compute the completed units for NSProgress
    func currentCompletedUnits() -> Int64 {
        let totalUploadedPaths = (assets ?? [])
            .filter{ $0.isUploaded }
            .count
        
        return Int64(totalUploadedPaths)
    }
}
