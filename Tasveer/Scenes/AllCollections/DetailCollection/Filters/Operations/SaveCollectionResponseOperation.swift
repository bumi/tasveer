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
    
    private var group: Group!
    private let createdCollection: (Group) -> Void
    
    init(createdCollection: @escaping (Group) -> Void) {
        self.createdCollection = createdCollection
        
        super.init()
        
        name = "Save Collection Response Operation"
    }
    
    override func execute() {
        guard let moc = PersistentStoreManager.shared.moc
            else { finishWithError(NSError(code: .executionFailed)); return }
        
        moc.performChangesAndWait {
            self.group = Group.insertNew(into: moc, fromCollection: self.collection)
        }
        
        // Throw back created collection
        createdCollection(group)
        
        finish()
    }
}
