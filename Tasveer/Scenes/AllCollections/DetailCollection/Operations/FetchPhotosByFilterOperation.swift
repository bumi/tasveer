//
//  FetchPhotosByFilterOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/8/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Photos

final class FetchPhotosByFilterOperation: Operation {
    private let manager = PHImageManager.default()
    
    override init() {
        super.init()
        
        addCondition(PhotosCondition())
        
        name = "Fetch Photos By Filter Operation"
    }
    
    override func execute() {
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        
//        let albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        let albums = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        debugPrint(albums.count)
        for i in 0..<albums.count {
            debugPrint(albums.object(at: i).localizedTitle)
        }
//        manager.requestImage(for: fetchResult.object(at: 0), targetSize: CGSize.zero, contentMode: PHImageContentMode.aspectFill, options: requestOptions()) { (im, err) in
//            debugPrint("Image is requested")
//        }
    }
    
    private func fetchOptions() -> PHFetchOptions {
        let fetchOption = PHFetchOptions()
        fetchOption.predicate = NSPredicate(format: "favorite == YES")
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        return fetchOption
    }
    
    private func requestOptions() -> PHImageRequestOptions {
        let requestOptions = PHImageRequestOptions()
        
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        return requestOptions
    }
}
