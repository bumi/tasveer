//
//  StartUploadingCollectionsOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 6/21/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class StartUploadingCollectionsOperation: GroupOperation {
    private let collections: [Collection]
    
    init(withCollections collections: [Collection]) {
        self.collections = collections
        
        super.init(operations: [])
        
        name = "Start Uploading Collections Operation"
    }
    
    override func execute() {
        let operations = collections
            .filter({ $0.syncStateValue == .none || ($0.syncStateValue == .syncing && $0.task?.isPaused == true) })
            .map(StartUploadingCollectionOperation.init)
        
        guard !operations.isEmpty else {
            finish()
            return
        }
        
        for operation in operations {
            addOperation(operation)
        }
        
        super.execute()
    }
}
