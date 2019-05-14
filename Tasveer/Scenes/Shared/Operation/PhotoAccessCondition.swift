//
//  PhotoAccessCondition.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/8/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Photos

struct PhotoAccessCondition: OperationCondition {
    static var name: String = "Photo Access Condition"
    static let authorizationStatusKey = "PHAuthorizationStatus"
    static var isMutuallyExclusive: Bool = false
    
    func dependencyForOperation(_ operation: Operation) -> Foundation.Operation? {
        return PhotoAccessOperation()
    }
    
    func evaluateForOperation(_ operation: Operation, completion: @escaping (OperationConditionResult) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        var error: NSError?
        
        switch status {
        case .authorized:
            break
        default:
            error = NSError(code: .conditionFailed, userInfo: [
                OperationConditionKey: type(of: self).name,
                type(of: self).authorizationStatusKey: status.rawValue
                ])
        }
        
        if let error = error {
            completion(.failed(error))
        } else {
            completion(.satisfied)
        }
    }
}

private class PhotoAccessOperation: Operation {
    var library: PHPhotoLibrary?
    
    override init() {
        super.init()
        
        /*
         This is an operation that potentially presents an alert so it should
         be mutually exclusive with anything else that presents an alert.
         */
        addCondition(AlertPresentation())
    }
    
    override func execute() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self] (status) in
                if status != .notDetermined {
                    self?.finish()
                } else {
                    assertionFailure("PHPhotoLibrary access status is still NotDetermined")
                }
            })
        default:
            finish()
        }
    }
}
