//
//  PersistentStoreManager.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation
import CoreData

private let ubiquityToken: String = {
    guard let token = FileManager.default.ubiquityIdentityToken,
        let string = try? NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: false).base64EncodedString(options: [])
        else { return "unknown" }
    return string.removingCharacters(in: CharacterSet.letters.inverted)
}()

private let storeURL = URL.documents.appendingPathComponent("\(ubiquityToken).tasveer")

final class PersistentStoreManager {
    static let shared = PersistentStoreManager()
    
    var currentContainer: NSPersistentContainer?
    
    var moc: NSManagedObjectContext? {
        return currentContainer?.viewContext
    }
    
    
    private let tasveerContainer: NSPersistentContainer = {
        let momdName = "Tasveer"
        let container = NSPersistentContainer(name: momdName, managedObjectModel: Version.current.managedObjectModel())
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.shouldMigrateStoreAutomatically = false
        container.persistentStoreDescriptions = [storeDescription]
        return container
    }()
    
    private init() {}
    
    func createMoodyContainer(migrating: Bool = false, progress: Progress? = nil, completion: @escaping (NSPersistentContainer) -> ()) {
        tasveerContainer.loadPersistentStores { [weak self] _, error in
            guard let sSelf = self else { fatalError("Failed to load store: \(error!)") }
            
            if error == nil {
                DispatchQueue.main.async { completion(sSelf.tasveerContainer) }
                
                self?.currentContainer = sSelf.tasveerContainer
                self?.moc?.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            } else {
                guard !migrating else { fatalError("was unable to migrate store") }
                DispatchQueue.global(qos: .userInitiated).async {
                    migrateStore(from: storeURL, to: storeURL, targetVersion: Version.current, deleteSource: true, progress: progress)
                    self?.createMoodyContainer(migrating: true, progress: progress,
                                               completion: completion)
                }
            }
        }
    }
}
