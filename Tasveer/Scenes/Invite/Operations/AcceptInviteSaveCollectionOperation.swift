//
//  AcceptInviteSaveCollectionOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/23/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class AcceptInviteSaveCollectionOperation: GroupOperation {
    private let inviteId: String
    private let collectionResponse: CollectionResponse
    
    init(forCollectionResponse collectionResponse: CollectionResponse, inviteId: String) {
        self.inviteId = inviteId
        self.collectionResponse = collectionResponse
        
        super.init(operations: [])
        
        name = "Accept Invite Save Collection Operation"
    }
    
    override func execute() {
        let accept = AcceptInviteOperation(with: inviteId)
        let save = SaveCollectionResponseOperation(filterModel: nil, createdCollection: {_ in})
        save.collectionResponse = collectionResponse
        
        save.addDependency(accept)
        
        addOperation(save)
        addOperation(accept)
        
        super.execute()
    }
}
