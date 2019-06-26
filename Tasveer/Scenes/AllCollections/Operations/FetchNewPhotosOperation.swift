//
//  FetchNewPhotosOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 6/20/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class FetchNewPhotosOperation: GroupOperation {
    private let collection: Collection
    
    init(withCollection collection: Collection) {
        self.collection = collection
        
        let store = StoreNewPhotosFromGalleryOperation(withCollection: collection)
        let fetch = FetchPhotosByFilterOperation(withCollectionFilter: collection.filter) { (fetchResult) in
            store.fetchResult = fetchResult
        }
        
        store.addDependency(fetch)
        
        super.init(operations: [fetch, store])
        
        name = "Fetch New Photos Operation"
    }
}
