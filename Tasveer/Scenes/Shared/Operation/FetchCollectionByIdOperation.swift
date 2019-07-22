//
//  FetchCollectionByIdOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/23/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class FetchCollectionByIdOperation: Operation {
    private let collectionId: String
    private let callback: (CollectionResponse) -> Void
    
    init(forCollectionId collectionId: String, callback: @escaping (CollectionResponse) -> Void) {
        self.collectionId = collectionId
        self.callback = callback
        
        super.init()
        
        name = "Fetch Collection By Id Operation"
    }
    
    override func execute() {
        API.fetchCollection(for: collectionId).responseParsed { [weak self] (res: Result<CollectionResponse, ResponseError>) in
            switch res {
            case .success(let collection):
                self?.callback(collection)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
            
            self?.finish()
        }
    }
}
