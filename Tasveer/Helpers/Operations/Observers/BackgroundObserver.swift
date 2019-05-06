//
//  BackgroundObserver.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 3/28/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

/**
 `BackgroundObserver` is an `OperationObserver` that will automatically begin
 and end a background task if the application transitions to the background.
 This would be useful if you had a vital `Operation` whose execution *must* complete,
 regardless of the activation state of the app. Some kinds network connections
 may fall in to this category, for example.
 */
class BackgroundObserver: NSObject, OperationObserver {
    // MARK: Properties
    
    fileprivate var identifier = UIBackgroundTaskIdentifier.invalid
    fileprivate var isInBackground = false
    
    override init() {
        super.init()
        
        // We need to know when the application moves to/from the background.
        NotificationCenter.default.addObserver(self, selector: #selector(BackgroundObserver.didEnterBackground(_:)), name:UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BackgroundObserver.didEnterForeground(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        isInBackground = UIApplication.shared.applicationState == .background
        
        // If we're in the background already, immediately begin the background task.
        if isInBackground {
            startBackgroundTask()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didEnterBackground(_ notification: Notification) {
        if !isInBackground {
            isInBackground = true
            startBackgroundTask()
        }
    }
    
    @objc func didEnterForeground(_ notification: Notification) {
        if isInBackground {
            isInBackground = false
            endBackgroundTask()
        }
    }
    
    fileprivate func startBackgroundTask() {
        if identifier == UIBackgroundTaskIdentifier.invalid {
            identifier = UIApplication.shared.beginBackgroundTask(withName: "BackgroundObserver", expirationHandler: {
                self.endBackgroundTask()
            })
        }
    }
    
    fileprivate func endBackgroundTask() {
        if identifier != UIBackgroundTaskIdentifier.invalid {
            UIApplication.shared.endBackgroundTask(identifier)
            identifier = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    // MARK: YMOperationObserver
    
    func operationDidStart(_ operation: Operation) { }
    
    func operation(_ operation: Operation, didProduceOperation newOperation: Foundation.Operation) { }
    
    func operationDidFinish(_ operation: Operation, errors: [NSError]) {
        endBackgroundTask()
    }
}
