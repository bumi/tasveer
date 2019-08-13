//
//  InviteResponse.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/22/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

struct InviteResponse: Codable {
    let identifier: String
    let email: String
    let collectionId: String
    let senderId: String?
    let userId: String?
    let acceptedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case email
        case collectionId = "collection_id"
        case senderId = "sender_id"
        case userId = "user_id"
        case acceptedAt = "accepted_at"
    }
}
