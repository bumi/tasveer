//
//  Photo.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/15/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import CoreData
import Photos

enum PhotoType: String {
    case local
    case global
}

enum PhotoStatus: String {
    case none
    case success
    case failed
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
    @NSManaged fileprivate(set) var createdAt: Date
    
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
        return [NSSortDescriptor(key: #keyPath(createdAt), ascending: false)]
    }
}

extension Photo {
    @discardableResult
    static func insertNewPhoto(into moc: NSManagedObjectContext, fromAsset asset: PHAsset, forCollection collection: Group, userId: String? = AuthManager.shared.token) -> Photo {
        let newPhoto: Photo = moc.insertObject()
        newPhoto.typeValue = .local
        newPhoto.statusValue = .none
        newPhoto.assetIdentifier = asset.localIdentifier
        newPhoto.userId = userId
        newPhoto.createdAt = Date()
        
        newPhoto.group = collection
        
        return newPhoto
    }
    
    static func insertNewPhoto(into moc: NSManagedObjectContext, fromPhotoResponse photo: PhotoResponse, forCollection collection: Group) -> Photo {
        let newPhoto: Photo = moc.insertObject()
        newPhoto.typeValue = .global
        newPhoto.statusValue = .none
        newPhoto.identifier = photo.identifier
        newPhoto.caption = photo.caption
        newPhoto.userId = photo.userId
        newPhoto.createdAt = Date()
        
        if let width = photo.width {
            newPhoto.width = NSNumber(value: width)
        }
        
        if let height = photo.height {
            newPhoto.height = NSNumber(value: height)
        }
        
        if let fileUrlString = photo.fileUrl, let fileUrl = URL(string: fileUrlString) {
            newPhoto.fileUrl = fileUrl
        }
        
        if let filePreviewString = photo.filePreview, let filePreview = URL(string: filePreviewString) {
            newPhoto.filePreview = filePreview
        }
        
        newPhoto.group = collection
        
        return newPhoto
    }
    
    // After photo is uploaded update the properties
    func postUploadProcess(status: PhotoStatus, photoResponse: PhotoResponse? = nil) {
        self.statusValue = status
        self.identifier = photoResponse?.identifier
    }
}
