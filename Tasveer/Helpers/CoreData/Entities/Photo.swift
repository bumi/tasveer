//
//  Photo.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/15/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import CoreData

enum PhotoType: String {
    case local
    case global
}

enum PhotoStatus: String {
    case none
    case syncing
    case synced
}

final class Photo: NSManagedObject {
    @NSManaged fileprivate(set) var type: String
    @NSManaged fileprivate(set) var status: String
    @NSManaged fileprivate(set) var assetIdentifier: String?
    @NSManaged fileprivate(set) var identifier: String?
    @NSManaged fileprivate(set) var caption: String?
    @NSManaged fileprivate(set) var width: NSNumber?
    @NSManaged fileprivate(set) var height: NSNumber?
    @NSManaged fileprivate(set) var fileUrl: URL?
    @NSManaged fileprivate(set) var filePreview: URL?
    @NSManaged fileprivate(set) var userId: String?
    @NSManaged fileprivate(set) var createdAt: Date?
    
    @NSManaged fileprivate(set) var group: Group
    
    var typeValue: PhotoType {
        set {
            type = newValue.rawValue
        }
        get {
            return PhotoType(rawValue: type) ?? .local
        }
    }
    
    var statusValue: PhotoStatus {
        set {
            status = newValue.rawValue
        }
        get {
            return PhotoStatus(rawValue: type) ?? .none
        }
    }
}

extension Photo: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}

extension Photo {
    static func insertNewPhoto(into moc: NSManagedObjectContext) -> Photo {
        let newPhoto: Photo = moc.insertObject()
        
        return newPhoto
    }
}
