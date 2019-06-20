//
//  FetchPhotosByFilterOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/8/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Photos

final class FetchPhotosByFilterOperation: Operation {
    private let collectionFilter: Filter
    
    private let manager = PHImageManager.default()
    
    private var resultFetched: ((PHFetchResult<PHAsset>?) -> Void)?
    
    var fetchResult: PHFetchResult<PHAsset>?
    
    init(withCollectionFilter collectionFilter: Filter, resultFetched: ((PHFetchResult<PHAsset>?) -> Void)?) {
        self.collectionFilter = collectionFilter
        self.resultFetched = resultFetched
        
        super.init()
        
        addCondition(PhotosCondition())
        
        name = "Fetch Photos By Filter Operation"
    }
    
    override func execute() {
        let album = collectionFilter.albumValue
        switch album {
        case .allPhotos:
            fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        case .userAlbum(_, let id),
             .smartAlbum(_, let id):
            if let collections = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [id], options: nil).firstObject {
                fetchResult = PHAsset.fetchAssets(in: collections, options: fetchOptions())
            }
        }
        
        resultFetched?(fetchResult)
        
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
        
        if collectionFilter.isFavorite {
            predicates.append(NSPredicate(format: "favorite == YES"))
        }
        if let fromTime = collectionFilter.fromTime {
            predicates.append(NSPredicate(format: "creationDate >= %@", fromTime as CVarArg))
        }
        if let toTime = collectionFilter.toTime {
            predicates.append(NSPredicate(format: "creationDate <= %@", toTime as CVarArg))
        }
        
        guard !predicates.isEmpty else { return nil }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}
