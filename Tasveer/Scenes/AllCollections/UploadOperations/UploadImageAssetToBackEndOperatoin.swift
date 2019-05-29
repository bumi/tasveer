//
//  UploadImageAssetToBackEndOperatoin.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/21/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import Alamofire
import Photos

final class UploadImageAssetToBackEndOperation: Operation {
    var asset: Photo?
    let progress: Progress
    
    init(withPhoto asset: Photo?, parentProgress: Progress) {
        self.asset = asset
        self.progress = Progress(totalUnitCount: 100, parent: parentProgress, pendingUnitCount: 1)

        super.init()

        name = "Upload Photo to Back End"
    }
    
    override func execute() {
        debugPrint("Start: \(name ?? "")")
        guard let asset = asset,
            let identifier = asset.assetIdentifier,
            let upAsset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject
            else {
                finishWithError(NSError(code: .executionFailed))
                return
        }
        
        let imageManager = PHCachingImageManager()
        imageManager.requestImageData(for: upAsset, options: nil) { [weak self] (data, error, _, _) in
            if let data = data {
                self?.buildRequest(fileData: data)
            } else if let error = error {
                debugPrint(error)
            }
        }
    }
    
    private func buildRequest(fileData data: Data) {
        let request = API.uploadPhoto(collectionId: asset?.group.identifier ?? "")
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(data, withName: "photo[file]", fileName: "image.png", mimeType: "image/png")
        }, with: request) { [weak self] (encodingResult) in
            switch encodingResult {
            case .success(let uploadRequest, _, _):
                self?.uploadPhoto(request: uploadRequest, attemptCounter: 0)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func uploadPhoto(request: UploadRequest, attemptCounter: Int) {
        guard let moc = PersistentStoreManager.shared.moc
            else {
                finishWithError(NSError(code: .executionFailed))
                return
        }
        
        // In case 3 attempts are over
        guard attemptCounter < 3
            else {
                moc.performChangesAndWait {
                    self.asset?.postUploadProcess(status: .failed)
                }
                
                finish()
                return
        }
        
        request.responseParsed(callback: { [weak self] (res: Swift.Result<PhotoResponse, ResponseError>) in
            switch res {
            case .success(let photo):
                moc.performChanges { [weak self] in
                    self?.asset?.postUploadProcess(status: .success, photoResponse: photo)
                    self?.finish()
                }
            case .failure:
                self?.progress.completedUnitCount = 0
                self?.uploadPhoto(request: request, attemptCounter: attemptCounter + 1)
                return
            }
        })
        
        request.uploadProgress { [weak self] (progress) in
            self?.progress.completedUnitCount = Int64(ceil(progress.fractionCompleted * 100))
        }
    }
}
