//
//  GroupResponse.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

struct GroupResponse: Codable {
    let name: String
    let createdAt: Date
    let identifier: String
    let users: [UserResponse]
    
    enum CodingKeys: String, CodingKey {
        case name
        case createdAt = "created_at"
        case identifier
        case users
    }
}
