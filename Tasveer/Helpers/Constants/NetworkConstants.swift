//
//  NetworkConstants.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/23/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

struct NetworkParamsKey {
    /// Filter response
    static let albumType = "album_type"
    static let albumName = "album_name"
    static let albumIdentifier = "album_identifier"
    static let isFavourite = "is_favorite"
    static let fromTime = "from_time"
    static let toTime = "to_time"
    
    /// Collection response
    static let name = "name"
    static let description = "description"
    static let filter = "filter"
}
