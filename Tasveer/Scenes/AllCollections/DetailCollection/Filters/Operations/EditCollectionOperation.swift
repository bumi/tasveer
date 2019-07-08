//
//  EditCollectionOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/1/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class EditCollectionOperation: Operation {
    private let filterModel: FiltersModel
    private let collection: Collection
    
    init(filterModel: FiltersModel, and collection: Collection) {
        self.filterModel = filterModel
        self.collection = collection
        
        super.init()
        
        name = "Edit Collection"
    }
    
    override func execute() {
        let params = [
            NetworkParamsKey.name: filterModel.name
        ]
        
        API.editCollection(params, identifier: collection.identifier).responseParsed { [weak self] (_: Result<CollectionResponse, ResponseError>) in
            self?.finish()
        }
    }
}
