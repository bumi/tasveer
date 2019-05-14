//
//  FetchAlbumNamesOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/9/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Photos

final class FetchAlbumNamesOperation: Operation {
    var smartAlbums: PHFetchResult<PHAssetCollection>
    var userCollection: PHFetchResult<PHCollection>
    
    var completion: ([String]) -> Void
    
    init(withCompletion completion: @escaping ([String]) -> Void) {
        self.completion = completion
        self.smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        self.userCollection = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        super.init()
    }
    
    override func execute() {
        var albumNames = ["All Photos"]
        
        for i in 0..<userCollection.count {
            if let title = userCollection.object(at: i).localizedTitle {
                albumNames.append(title)
            }
        }
        
        for i in 0..<smartAlbums.count {
            if let title = smartAlbums.object(at: i).localizedTitle {
                albumNames.append(title)
            }
        }
        
        completion(albumNames)
        finish()
    }
}
