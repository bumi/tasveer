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
//    var asset: Photo?
    let progress: Progress
    let identifier: String
    
//    init(withPhoto asset: Photo?, parentProgress: Progress) {
//        self.asset = asset
//        self.progress = Progress(totalUnitCount: 100, parent: parentProgress, pendingUnitCount: 1)
//
//        super.init()
//
//        name = "Upload Photo to Back End"
//    }
    init(withPhoto identifier: String, parentProgress: Progress) {
        self.identifier = identifier
        self.progress = Progress(totalUnitCount: 100, parent: parentProgress, pendingUnitCount: 1)
        
        super.init()
        
        name = "Upload Photo to Back End"
    }
    
    override func execute() {
        debugPrint("Start: \(name ?? "")")
//        guard let asset = asset,
//            let identifier = asset.assetIdentifier,
            guard let upAsset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject
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
        let request = API.uploadPhoto(collectionId: "cln-dedf0a07-fa8b-4b63-93e3-70a598b")//asset?.group.identifier ?? "")
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(data, withName: "photo[file]", fileName: "image.png", mimeType: "image/png")
            formData.append("Test Caption".data(using: .utf8)!, withName: "photo[caption]")
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
        request.responseParsed(callback: { (res: Swift.Result<PhotoResponse, ResponseError>) in
            switch res {
            case .success(let photo):
                dump(photo)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        })
        
        request.uploadProgress { (progress) in
            debugPrint(progress)
        }
    }
}
