//
//  FetchNewPhotosForAllCollectionsOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 6/20/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class FetchNewPhotosForAllCollectionsOperation: GroupOperation {
    init(withCollections collections: [Collection]) {
        let operations = collections.map(FetchNewPhotosOperation.init)
        
        super.init(operations: operations)
        
        name = "Fetch New Photos For All Collections Operation"
    }
}
