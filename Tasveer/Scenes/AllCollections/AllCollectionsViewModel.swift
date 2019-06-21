//
//  AllCollectionsViewModel.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/24/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class AllCollectionsViewModel {
    private let queue = OperationQueue()
    
    func fetchNewPhotosIfNeeded(for objects: [Collection?]) {
        let collections = objects.compactMap{ $0 }
        
        let fetch = FetchNewPhotosForAllCollectionsOperation(withCollections: collections)
        let upload = StartUploadingCollectionsOperation(withCollections: collections)
        upload.addDependency(fetch)
        
        fetch.addCompletionBlock {
            debugPrint("Fetch is completed")
        }
        
        queue.addOperation(fetch)
        queue.addOperation(upload)
    }
    
    func startUploadIfNeeded(for objects: [Collection?]) {
        guard queue.operationCount <= 0 else { return }
        
        let collections = objects.compactMap{ $0 }
        let operation = StartUploadingCollectionsOperation(withCollections: collections)
        queue.addOperation(operation)
    }
    
    func startUpload(for object: Collection?) {
        let operation = StartUploadingCollectionOperation(with: object)
        queue.addOperation(operation)
    }
}
