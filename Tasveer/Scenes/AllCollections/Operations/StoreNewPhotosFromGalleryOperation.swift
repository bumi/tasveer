//
//  StoreNewPhotosFromGalleryOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 6/20/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation
import Photos

final class StoreNewPhotosFromGalleryOperation: Operation {
    private let collection: Collection
    
    var fetchResult: PHFetchResult<PHAsset>?
    
    init(withCollection collection: Collection) {
        self.collection = collection
        
        super.init()
        
        name = "Store New Photos From Gallery Operation"
    }
    
    override func execute() {
        guard let fetchResult = fetchResult else { finish(); return }
        
        if fetchResult.count > 0 {
            var assets: [PHAsset] = []
            
            let lastPhotoDate = collection.photos?
                .sorted(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending })
                .last?.createdAt ?? Date(timeIntervalSince1970: 0)
            
            for i in (0..<fetchResult.count).reversed() {
                let phAsset = fetchResult.object(at: i)
                if phAsset.creationDate!.compare(lastPhotoDate) == .orderedDescending {
                    assets.append(phAsset)
                } else {
                    break
                }
            }
            
            let moc = PersistentStoreManager.shared.moc
            
            moc?.performChanges {
                if !assets.isEmpty {
                    self.collection.syncStateValue = .none
                    self.collection.removeTask(forMoc: moc)
                }
                
                for phAsset in assets {
                    Photo.insertNewPhoto(into: moc!, fromAsset: phAsset, forCollection: self.collection)
                }
                
                self.finish()
            }
        } else {
            finish()
        }
    }
}
