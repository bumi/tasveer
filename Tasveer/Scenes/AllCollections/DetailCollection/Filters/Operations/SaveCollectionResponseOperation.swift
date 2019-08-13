//
//  SaveCollectionResponseOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/23/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class SaveCollectionResponseOperation: Operation {
    var collectionResponse: CollectionResponse!
    
    private let filterModel: FiltersModel?
    private var collection: Collection!
    private let createdCollection: (Collection) -> Void
    
    init(filterModel: FiltersModel?, createdCollection: @escaping (Collection) -> Void) {
        self.filterModel = filterModel
        self.createdCollection = createdCollection
        
        super.init()
        
        name = "Save Collection Response Operation"
    }
    
    override func execute() {
        guard let moc = PersistentStoreManager.shared.moc
            else { finishWithError(NSError(code: .executionFailed)); return }
        
        moc.performChangesAndWait {
            self.collection = Collection.insertNew(into: moc, fromCollection: self.collectionResponse, filter: self.filterModel)
        }
        
        // Throw back created collection
        createdCollection(collection)
        
        finish()
    }
}
