//
//  UploadAllImageAssetsToBackEndOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/24/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class UploadAllImageAssetsToBackEndOperation: GroupOperation {
    private let collection: Collection?
    private var uploadOperations: [UploadImageAssetToBackEndOperation]
    
    init(with collection: Collection?, withProgress parentProgress: Progress) {
        self.collection = collection
        
        let totalPhotos = collection?.unfinishedPhotoUploads ?? 0
        let childProgress = Progress(totalUnitCount: totalPhotos,
                                     parent: parentProgress,
                                     pendingUnitCount: totalPhotos)
        
        var operations: [UploadImageAssetToBackEndOperation] = []
        
        let images = (collection?.photos ?? []).sorted(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending })
        for image in images where image.statusValue != .success {
            let operation = UploadImageAssetToBackEndOperation(withPhoto: image, parentProgress: childProgress)
            operations.append(operation)
            
            operation.addCompletionBlock {
                let moc = PersistentStoreManager.shared.moc
                moc?.performChanges {
                    collection?.task?.updateTask(assetUploaded: image.assetIdentifier)
                }
            }
        }
        
        self.uploadOperations = operations
        
        super.init(operations: operations, maxConcurrentOperationCount: 4)
        
        name = "Upload Photos to back-end"
    }
}
