//
//  CreateNetworkCollectionOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/23/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class CreateNetworkCollectionOperation: Operation {
    private let filterModel: FiltersModel
    private let fetchedCollection: (CollectionResponse) -> Void
    
    private var createdParams: [String : Any] {
        let formatter = DateFormatter.iso8601
        
        let fromDate: String? = filterModel.fromDate != nil ? formatter.string(from: filterModel.fromDate!) : nil
        let toDate: String? = filterModel.toDate != nil ? formatter.string(from: filterModel.toDate!) : nil
        
        let filter: [String : Any] = [
            NetworkParamsKey.albumType: filterModel.pickedAlbum.type,
            NetworkParamsKey.albumName: filterModel.pickedAlbum.title,
            NetworkParamsKey.albumIdentifier: filterModel.pickedAlbum.identifier as Any,
            NetworkParamsKey.isFavourite: filterModel.isFavorite,
            NetworkParamsKey.fromTime: fromDate as Any,
            NetworkParamsKey.toTime: toDate as Any
        ]
        
        let params: [String : Any] = [
            NetworkParamsKey.name: filterModel.name,
            NetworkParamsKey.filter: filter
        ]
        
        return params
    }
    
    init(withFilterModel filterModel: FiltersModel, fetchedCollection: @escaping (CollectionResponse) -> Void) {
        self.filterModel = filterModel
        self.fetchedCollection = fetchedCollection
        
        super.init()
        
        name = "Create Network Collection Operation"
    }
    
    override func execute() {
        API.createCollection(createdParams).responseParsed { [weak self] (res: Swift.Result<CollectionResponse, ResponseError>) in
            switch res {
            case .success(let collection):
                self?.fetchedCollection(collection)
                self?.finish()
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self?.finishWithError(NSError(code: .conditionFailed))
            }
        }
    }
}
