//
//  UploadAsset.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/20/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import CoreData

final class UploadAsset: NSManagedObject {
    @NSManaged fileprivate(set) var assetIdentifier: String
    @NSManaged fileprivate(set) var isUploaded: Bool
    
    @NSManaged fileprivate(set) var task: UploadTask
}

extension UploadAsset: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}

extension UploadAsset {
    static func insertNewAsset(into moc: NSManagedObjectContext, with assetIdentifier: String) -> UploadAsset {
        let newAsset: UploadAsset = moc.insertObject()
        newAsset.assetIdentifier = assetIdentifier
        newAsset.isUploaded = false
        
        return newAsset
    }
    
    func updateIsUploaded(_ uploaded: Bool) {
        isUploaded = uploaded
    }
}
