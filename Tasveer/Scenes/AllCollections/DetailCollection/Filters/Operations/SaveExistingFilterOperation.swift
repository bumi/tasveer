//
//  SaveExistingFilterOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/1/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class SaveExistingFilterOperation: Operation {
    private let filterModel: FiltersModel
    private var collection: Collection
    
    init(filterModel: FiltersModel, and collection: Collection) {
        self.filterModel = filterModel
        self.collection = collection
        
        super.init()
        
        name = "Save Existing Filter"
    }
    
    override func execute() {
        filterModel.save(intoFilter: collection.filter)
        finish()
    }
}
