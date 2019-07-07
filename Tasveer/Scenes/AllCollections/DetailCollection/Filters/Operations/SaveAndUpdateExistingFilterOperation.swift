//
//  SaveExistingFilterOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/1/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class SaveAndUpdateExistingFilterOperation: GroupOperation {
    private let filterModel: FiltersModel
    private var collection: Collection
    
    init(filterModel: FiltersModel, and collection: Collection) {
        self.filterModel = filterModel
        self.collection = collection
        
        let edit = EditCollectionOperation(filterModel: filterModel, and: collection)
        let save = SaveExistingFilterOperation(filterModel: filterModel, and: collection)
        edit.addDependency(save)
        
        super.init(operations: [edit, save])
        
        name = "Save And Update Existing Filter"
    }
    
}
