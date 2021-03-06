//
//  FiltersModel.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/7/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

let CollectionFilterValueIsChangedKey = "CollectionFilterValueIsChangedKey"

enum AlbumName: Equatable {
    static let allPhotosType: String = "all_photos"
    static let userAlbumType: String = "user_album"
    static let smartAlbumType: String = "smart_album"
    
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

final class FiltersModel {
    var pickedAlbum: AlbumName
    var fromDate: Date?
    var toDate: Date?
    var isFavorite: Bool
    var name: String = ""
    
    private var isEmpty: Bool {
        return fromDate == nil && toDate == nil && !isFavorite
    }
    
    init(with filter: Filter) {
        self.pickedAlbum = filter.albumValue
        self.isFavorite = filter.isFavorite
        self.fromDate = filter.fromTime
        self.toDate = filter.toTime
    }
    
    init() {
        self.pickedAlbum = AlbumName.allPhotos
        self.isFavorite = false
        self.fromDate = nil
        self.toDate = nil
    }
    
    func save(intoFilter filter: Filter) {
        guard let moc = PersistentStoreManager.shared.moc
            else { return }
        
        moc.performChangesAndWait { [unowned self] in
            filter.update(byFilterModel: self)
        }
    }
    
    // If any error occurs, it will be returned as String.
    // If no errors available, nil will be returned
    func validate() -> String? {
        if pickedAlbum == .allPhotos, isEmpty {
            return "Can't add filter for All Photos without any defined properties."
        }
        if name.isEmpty {
            return "Can't save album with empty name. Please enter the album's name"
        }
        
        return nil
    }
}
