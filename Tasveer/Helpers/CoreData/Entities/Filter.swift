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
    
    @NSManaged fileprivate(set) var group: Group
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
}
