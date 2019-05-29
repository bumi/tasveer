//
//  CollectionPeopleModel.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/7/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class CollectionPeopleModel {
    let collection: Collection?
    var emails: [String] = []
    
    init(withCollection collection: Collection?) {
        self.collection = collection
        populate()
    }
    
    private func populate() {
        guard let collection = collection else { return }
        
        let users = Array(collection.users)
        emails = users.compactMap({ $0.email })
    }
}
