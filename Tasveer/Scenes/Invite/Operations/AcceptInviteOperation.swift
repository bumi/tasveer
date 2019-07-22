//
//  AcceptInviteOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/22/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

final class AcceptInviteOperation: Operation {
    private let inviteId: String
    
    init(with inviteId: String) {
        self.inviteId = inviteId
        
        super.init()
        
        name = "Accept Invite Operation"
    }
    
    override func execute() {
//        API.acceptInvite(for: inviteId).responseParsed(callback: <#T##(Result<Decodable & Encodable, ResponseError>) -> Void#>)
    }
}
