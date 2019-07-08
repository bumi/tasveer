//
//  PickPhotoOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 7/1/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import Photos

final class PickPhotoOperation: Operation {
    private let collection: Collection
    private let photoAddedCallback: () -> Void
    
    init(collection: Collection, photoAddedCallback: @escaping () -> Void) {
        self.collection = collection
        self.photoAddedCallback = photoAddedCallback
        
        super.init()
        
        name = "Pick Photo Operation"
    }
    
    override func execute() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = ["public.image"]
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        
        DispatchQueue.main.async {
            AppDelegateManager.currentNavigationController?.present(picker, animated: true, completion: nil)
        }
    }
}

extension PickPhotoOperation: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let moc = PersistentStoreManager.shared.moc,
            let phAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
            else {
                finish()
                return
        }
        
        moc.performChangesAndWait { [unowned self] in
            Photo.insertNewPhoto(into: moc, fromAsset: phAsset, forCollection: self.collection)
        }
        
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: { [weak self] in
                self?.photoAddedCallback()
                self?.finish()
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.finish()
    }
}
