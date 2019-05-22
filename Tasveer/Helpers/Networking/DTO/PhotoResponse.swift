//
//  PhotoResponse.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/15/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

struct PhotoResponse: Codable {
    let identifier: String
    let caption: String?
    let width: Double?
    let height: Double?
    let fileUrl: String?
    let filePreview: String?
    let tagNames: [String]?
    let userId: String
    let collectionIds: [String]
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case caption
        case width
        case height
        case fileUrl = "file_url"
        case filePreview = "file_preview"
        case tagNames = "tag_names"
        case userId = "user_id"
        case collectionIds = "collection_ids"
    }
}
