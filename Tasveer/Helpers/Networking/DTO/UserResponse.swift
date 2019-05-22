//
//  UserResponse.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let name: String?
    let email: String?
    let deviceId: String?
    let identifier: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case deviceId = "device_id"
        case identifier
    }
}
