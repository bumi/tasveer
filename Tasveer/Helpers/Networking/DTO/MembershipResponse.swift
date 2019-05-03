//
//  MembershipResponse.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

struct MembershipResponse: Codable {
    let groupId: Int
    let userId: Int
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case groupId = "group_id"
        case userId = "user_id"
        case createdAt = "created_at"
    }
}
