//
//  UploadWillTerminateObserver.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/21/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

/**
 `UploadWillTerminateObserver` is an `OperationObserver` that will be called
 when app will be terminated. This observer
 */
class UploadWillTerminateObserver: NSObject, OperationObserver {
    // MARK: Properties
    private var collection: Collection?
    
    init(withCollection collection: Collection?) {
        self.collection = collection
        
        super.init()
        
        // We need to know when the application moves to/from the background.
        NotificationCenter.default.addObserver(self, selector: #selector(UploadWillTerminateObserver.willTerminate(_:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func willTerminate(_ notification: Notification) {
        saveCurrentState()
    }
    
    private func saveCurrentState() {
        guard let moc = PersistentStoreManager.shared.moc
            else { return }
        
        moc.performChangesAndWait { [weak self] in
            self?.collection?.saveState()
        }
    }
    
    // MARK: YMOperationObserver
    
    func operationDidStart(_ operation: Operation) { }
    
    func operation(_ operation: Operation, didProduceOperation newOperation: Foundation.Operation) { }
    
    func operationDidFinish(_ operation: Operation, errors: [NSError]) {  }
}
