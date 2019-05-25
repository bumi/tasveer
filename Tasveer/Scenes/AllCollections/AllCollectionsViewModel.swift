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
    
    func startUploadIfNeeded(for objects: [Group?]) {
        let groups = objects.compactMap{ $0 }
        for obj in groups where obj.syncStateValue == .none || (obj.syncStateValue == .syncing && obj.task?.isPaused == true) {
            let operation = StartUploadingCollectionOperation(with: obj)
            queue.addOperation(operation)
        }
    }
    
    func startUpload(for object: Group?) {
        let operation = StartUploadingCollectionOperation(with: object)
        queue.addOperation(operation)
    }
}
