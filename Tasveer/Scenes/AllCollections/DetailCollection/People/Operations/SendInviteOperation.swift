//
//  SendInviteOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/23/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class SendInviteOperation: Operation {
    private let email: String
    private let collectionId: String
    
    init(withEmail email: String, collectionId: String) {
        self.email = email
        self.collectionId = collectionId
        
        super.init()
        
        name = "Send Invite Operation"
    }
    
    override func execute() {
        let params: [String: Any] = [
            "email": email
        ]
        
        API.invitePerson(params, identifier: collectionId).responseParsed { [weak self] (_: Result<InviteResponse, ResponseError>) in
            self?.finish()
        }
    }
}
