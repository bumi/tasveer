//
//  SaveCollectionResponseOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/23/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class SaveCollectionResponseOperation: Operation {
    var collection: CollectionResponse!
    
    private let filterModel: FiltersModel
    private var group: Group!
    private let createdCollection: (Group) -> Void
    
    init(filterModel: FiltersModel, createdCollection: @escaping (Group) -> Void) {
        self.filterModel = filterModel
        self.createdCollection = createdCollection
        
        super.init()
        
        name = "Save Collection Response Operation"
    }
    
    override func execute() {
        guard let moc = PersistentStoreManager.shared.moc
            else { finishWithError(NSError(code: .executionFailed)); return }
        
        moc.performChangesAndWait {
            self.group = Group.insertNew(into: moc, fromCollection: self.collection, filter: self.filterModel)
        }
        
        // Throw back created collection
        createdCollection(group)
        
        finish()
    }
}
