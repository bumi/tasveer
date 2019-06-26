//
//  ApplyFilterOpertion.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 6/20/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation
import Photos

final class ApplyFilterOperation: GroupOperation {
    init(withCollectionFilter collectionFilter: Filter) {
        let storeOperation = StoreNewPhotosIntoDatabaseOperation(withCollectionFilter: collectionFilter)
        let fetchOperation = FetchPhotosByFilterOperation(withCollectionFilter: collectionFilter, resultFetched: { fetchResult in
            storeOperation.fetchResult = fetchResult
        })
        storeOperation.addDependency(fetchOperation)
        
        super.init(operations: [fetchOperation, storeOperation])
        
        name = "Apply Filter Operation"
    }
}
