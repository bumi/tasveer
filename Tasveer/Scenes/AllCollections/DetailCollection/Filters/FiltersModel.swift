//
//  FiltersModel.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/7/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

let GroupFilterValueIsChangedKey = "GroupFilterValueIsChangedKey"

enum AlbumName: Equatable {
    case allPhotos
    case userAlbum(String)
    case smartAlbum(String)
    
    var title: String {
        switch self {
        case .allPhotos:
            return "All Photos"
        case .userAlbum(let name),
             .smartAlbum(let name):
            return name
        }
    }
}

func ==(lhs: AlbumName, rhs: AlbumName) -> Bool {
    switch (lhs, rhs) {
    case (.allPhotos, .allPhotos):
        return true
        case (.userAlbum(let leftName), .userAlbum(let rightName)),
             (.smartAlbum(let leftName), .smartAlbum(let rightName)):
        return leftName == rightName
    default:
        return false
    }
}

final class GroupFilter: NSObject {
    var albumName: AlbumName {
        didSet {
            if albumName != oldValue {
                NotificationCenter.default.post(name: NSNotification.Name(GroupFilterValueIsChangedKey), object: self)
            }
        }
    }
    
    var isFavorite: Bool {
        didSet {
            if isFavorite != oldValue {
                NotificationCenter.default.post(name: NSNotification.Name(GroupFilterValueIsChangedKey), object: self)
            }
        }
    }
    
    var fromTimeframe: Date? {
        didSet {
            if fromTimeframe != nil, fromTimeframe != oldValue {
                NotificationCenter.default.post(name: NSNotification.Name(GroupFilterValueIsChangedKey), object: self)
            }
        }
    }
    
    var toTimeframe: Date? {
        didSet {
            if toTimeframe != nil, toTimeframe != oldValue {
                NotificationCenter.default.post(name: NSNotification.Name(GroupFilterValueIsChangedKey), object: self)
            }
        }
    }
    
    init(withAlbumName albumName: AlbumName, isFavorite: Bool = false) {
        self.albumName = albumName
        self.isFavorite = isFavorite
    }
}

final class FiltersModel {
    
}
