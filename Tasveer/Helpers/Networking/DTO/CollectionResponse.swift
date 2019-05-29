//
//  CollectionResponse.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

struct CollectionResponse: Codable {
    let name: String
    let description: String?
    let createdAt: Date
    let identifier: String
    let photos: [PhotoResponse]
    let users: [UserResponse]
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case createdAt = "created_at"
        case identifier
        case photos
        case users
    }
}
