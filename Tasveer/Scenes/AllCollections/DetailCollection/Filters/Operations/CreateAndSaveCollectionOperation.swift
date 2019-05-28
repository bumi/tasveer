//
//  CreateAndSaveCollectionOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/23/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class CreateAndSaveCollectionOperation: GroupOperation {
    
    init(filterModel: FiltersModel, createdCollection: @escaping (Collection) -> Void) {
        let saveOperation = SaveCollectionResponseOperation(filterModel: filterModel, createdCollection: createdCollection)
        let createOperation = CreateNetworkCollectionOperation(withFilterModel: filterModel) { (resp) in
            saveOperation.collectionResponse = resp
        }
        
        saveOperation.addDependency(createOperation)
        
        super.init(operations: [createOperation, saveOperation])
        
        name = "Create And Save Collection Operation"
    }
}
