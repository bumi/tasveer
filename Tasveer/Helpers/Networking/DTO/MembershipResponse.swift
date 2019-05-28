//
//  MembershipResponse.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

struct MembershipResponse: Codable {
    let collectionId: Int
    let userId: Int
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case collectionId = "collection_id"
        case userId = "user_id"
        case createdAt = "created_at"
    }
}
