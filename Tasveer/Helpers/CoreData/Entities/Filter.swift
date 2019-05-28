//
//  Filter.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/13/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import CoreData

final class Filter: NSManagedObject {
    @NSManaged fileprivate(set) var albumType: String?
    @NSManaged fileprivate(set) var albumName: String?
    @NSManaged fileprivate(set) var albumIdentifier: String?
    @NSManaged fileprivate(set) var isFavorite: Bool
    @NSManaged fileprivate(set) var fromTime: Date?
    @NSManaged fileprivate(set) var toTime: Date?
    
    @NSManaged fileprivate(set) var collection: Collection
    
    var albumValue: AlbumName {
        set {
            albumType = newValue.type
            albumName = newValue.title
            albumIdentifier = newValue.identifier
        }
        
        get {
            let s = AlbumName(withType: albumType, name: albumName, id: albumIdentifier)
            return s
        }
    }
}

extension Filter: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}

extension Filter {
    static func insertNewFilter(into moc: NSManagedObjectContext) -> Filter {
        let newFilter: Filter = moc.insertObject()
        newFilter.albumName = nil
        newFilter.albumIdentifier = nil
        newFilter.isFavorite = false
        newFilter.fromTime = nil
        newFilter.toTime = nil
        
        return newFilter
    }
    
    static func insertNewFilter(into moc: NSManagedObjectContext, fromFilterModel filterModel: FiltersModel) -> Filter {
        let newFilter: Filter = moc.insertObject()
        newFilter.albumValue = filterModel.pickedAlbum
        newFilter.isFavorite = filterModel.isFavorite
        newFilter.fromTime = filterModel.fromDate
        newFilter.toTime = filterModel.toDate
        
        return newFilter
    }
    
    func update(byFilterModel model: FiltersModel) {
        albumValue = model.pickedAlbum
        isFavorite = model.isFavorite
        fromTime = model.fromDate
        toTime = model.toDate
        
        // When changing the filter, we need to switch back the collection syncState to .none,
        // to tell the app that we need to upload new photos
        collection.syncStateValue = .none
    }
}
