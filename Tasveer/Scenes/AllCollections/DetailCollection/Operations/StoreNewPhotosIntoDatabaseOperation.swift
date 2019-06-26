//
//  StoreNewPhotosIntoDatabaseOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 6/20/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation
import Photos

final class StoreNewPhotosIntoDatabaseOperation: Operation {
    private let collectionFilter: Filter
    
    var fetchResult: PHFetchResult<PHAsset>?
    
    init(withCollectionFilter collectionFilter: Filter) {
        self.collectionFilter = collectionFilter
        
        super.init()
        
        name = "Store New Photos Into Database Operation"
    }
    
    override func execute() {
        let moc = PersistentStoreManager.shared.moc
        
        self.collectionFilter.collection.preFilterCleanup(forMoc: moc)
        
        moc?.performChangesAndWait {
            for i in 0..<(self.fetchResult?.count ?? 0) {
                if let obj = self.fetchResult?.object(at: i) {
                    debugPrint(obj.creationDate ?? Date())
                    Photo.insertNewPhoto(into: moc!, fromAsset: obj, forCollection: self.collectionFilter.collection)
                }
            }
        }
        
        // new photos will be added
        NotificationCenter.default.post(name: NSNotification.Name("NewCollectionInserted"), object: nil, userInfo: ["insertedCollection": collectionFilter.collection])
        
        finish()
    }
}
