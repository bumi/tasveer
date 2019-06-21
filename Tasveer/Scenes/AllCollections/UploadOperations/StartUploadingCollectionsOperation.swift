//
//  StartUploadingCollectionsOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 6/21/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class StartUploadingCollectionsOperation: GroupOperation {
    init(withCollections collections: [Collection]) {
        let operations = collections
            .filter({ $0.syncStateValue == .none || ($0.syncStateValue == .syncing && $0.task?.isPaused == true) })
            .map(StartUploadingCollectionOperation.init)
        
        super.init(operations: operations)
    }
}
