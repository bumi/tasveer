//
//  StartUploadingCollectionOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/24/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation
import CoreData

final class StartUploadingCollectionOperation: GroupOperation {
    let collection: Collection?
    
    @objc dynamic let progress: Progress
    
    init(with collection: Collection?) {
        self.collection = collection
        self.progress = Progress(totalUnitCount: collection?.totalUnitsToBeUploaded ?? 0)
        
        super.init(operations: [])
        
        startOrResume()
        
        name = "Start Uploading Collection"
        
        progress.addObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted), options: [.new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(Progress.fractionCompleted) {
            if let val = (change?[.newKey] as? NSNumber)?.floatValue {
                guard let moc = PersistentStoreManager.shared.moc
                    else { fatalError() }
                
                moc.performChangesAndWait { [weak self] in
                    self?.collection?.updateProgress(value: val)
                }
            }
        }
    }
    
    override func execute() {
        debugPrint("Start: \(name ?? "")")
        guard let moc = PersistentStoreManager.shared.moc
            else { fatalError() }
        
        moc.performChanges {
            self.collection?.syncStateValue = CollectionSyncState.syncing
        }
        
        super.execute()
    }
    
    override func finished(_ errors: [NSError]) {
        debugPrint("End: \(name ?? "")")
        guard let moc = PersistentStoreManager.shared.moc
            else { fatalError() }
        
        let failed = (collection?.photos ?? []).contains(where: { $0.statusValue == .failed })
        
        moc.performChangesAndWait {
            self.collection?.syncStateValue = failed ? .none : .synced
            self.collection?.removeTask(forMoc: moc)
        }
        
        super.finished(errors)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func startOrResume() {
        let moc = PersistentStoreManager.shared.moc
        
        let isNew = createNewTaskIfNeeded(inMoc: moc)
        
        if let _ = uploadPhotosIsNeeded(isNewTask: isNew, inMoc: moc) {
            runOnMain {
                let backgroundObserver = BackgroundObserver()
                self.addObserver(backgroundObserver)
            }
            
            let terminateObserver = UploadWillTerminateObserver(withCollection: collection)
            addObserver(terminateObserver)
        }
    }
    
    
    /// This function validates if it's resume operations or fresh new upload operation
    /// If operation is new upload then create new upload task
    /// If operation is resume then compute the current progress and resume the task
    ///
    /// - Parameter moc: NSManagedObjectContext
    /// - Returns: Bool, is new task
    private func createNewTaskIfNeeded(inMoc moc: NSManagedObjectContext?) -> Bool {
        if let task = collection?.task {
            task.resume()
            
            let currentCompletedUnit = task.currentCompletedUnits()
            progress.completedUnitCount = currentCompletedUnit
            
            return false
        } else {
            moc?.performChangesAndWait {
                self.collection?.newTask(fromMoc: moc!)
            }
            
            self.progress.totalUnitCount = collection?.totalUnitsToBeUploaded ?? 0
            
            return true
        }
    }
    
    private func uploadPhotosIsNeeded(isNewTask isNew: Bool, inMoc moc: NSManagedObjectContext?) -> Operation? {
        if let photos = collection?.photos, !photos.isEmpty {
            let operation = UploadAllImageAssetsToBackEndOperation(with: collection, withProgress: progress)
            addOperation(operation)
            
            return operation
        }
        
        return nil
    }
}
