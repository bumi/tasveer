//
//  CollectionPeopleModel.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/7/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class CollectionPeopleModel {
    let group: Group?
    var emails: [String] = []
    
    init(withGroup group: Group?) {
        self.group = group
        populate()
    }
    
    private func populate() {
        guard let group = group else { return }
        
        let users = Array(group.users)
        emails = users.compactMap({ $0.email })
    }
}
