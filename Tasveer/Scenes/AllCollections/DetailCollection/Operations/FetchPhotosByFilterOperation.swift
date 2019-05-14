//
//  FetchPhotosByFilterOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/8/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Photos

final class FetchPhotosByFilterOperation: Operation {
    private let groupFilter: Filter
    
    private let manager = PHImageManager.default()
    
    var fetchResult: PHFetchResult<PHAsset>?
    
    init(withGroupFilter groupFilter: Filter) {
        self.groupFilter = groupFilter
        
        super.init()
        
        addCondition(PhotosCondition())
        
        name = "Fetch Photos By Filter Operation"
    }
    
    override func execute() {
        let album = groupFilter.albumValue
        switch album {
        case .allPhotos:
            fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        case .userAlbum(_, let id):
            if let userCollections = PHCollectionList.fetchCollectionLists(withLocalIdentifiers: [id], options: nil).firstObject,
                let userCollection = PHCollectionList.fetchCollections(in: userCollections, options: nil).firstObject,
                let assetCollection = userCollection as? PHAssetCollection {
                fetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions())
            }
        case .smartAlbum(_, let id):
            if let smartCollections = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [id], options: nil).firstObject {
                fetchResult = PHAsset.fetchAssets(in: smartCollections, options: fetchOptions())
            }
        }
        
        finish()
    }
    
    private func fetchOptions() -> PHFetchOptions {
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        if let predicate = compoundedPredicates() {
            fetchOption.predicate = predicate
        }
        
        return fetchOption
    }
    
    private func requestOptions() -> PHImageRequestOptions {
        let requestOptions = PHImageRequestOptions()
        
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        return requestOptions
    }
    
    // Compound all predicates
    private func compoundedPredicates() -> NSPredicate? {
        var predicates: [NSPredicate] = []
        
        if groupFilter.isFavorite {
            predicates.append(NSPredicate(format: "favorite == YES"))
        }
        if let fromTime = groupFilter.fromTime {
            predicates.append(NSPredicate(format: "creationDate >= %@", fromTime as CVarArg))
        }
        if let toTime = groupFilter.toTime {
            predicates.append(NSPredicate(format: "creationDate <= %@", toTime as CVarArg))
        }
        
        guard !predicates.isEmpty else { return nil }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}
