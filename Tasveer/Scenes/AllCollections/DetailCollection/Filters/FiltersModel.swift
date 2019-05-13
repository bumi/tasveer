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
    private static let allPhotosType: String = "all_photos"
    private static let userAlbumType: String = "user_album"
    private static let smartAlbumType: String = "smart_album"
    
    case allPhotos
    case userAlbum(String, String)
    case smartAlbum(String, String)
    
    var title: String {
        switch self {
        case .allPhotos:
            return "All Photos"
        case .userAlbum(let name, _),
             .smartAlbum(let name, _):
            return name
        }
    }
    
    var identifier: String? {
        switch self {
        case .allPhotos:
            return nil
        case .userAlbum(_, let id),
             .smartAlbum(_, let id):
            return id
        }
    }
    
    var type: String {
        switch self {
        case .allPhotos:
            return AlbumName.allPhotosType
        case .userAlbum:
            return AlbumName.userAlbumType
        case .smartAlbum:
            return AlbumName.smartAlbumType
        }
    }
    
    init(withType: String?, name: String?, id: String?) {
        guard let type = withType, let name = name, let id = id else {
            self = .allPhotos
            return
        }
        
        switch type {
        case AlbumName.userAlbumType:
            self = .userAlbum(name, id)
        case AlbumName.smartAlbumType:
            self = .smartAlbum(name, id)
        default:
            self = .allPhotos
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
