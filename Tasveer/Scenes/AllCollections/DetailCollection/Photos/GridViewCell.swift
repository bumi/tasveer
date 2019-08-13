//
//  GridViewCell.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/13/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import Photos
import Nuke

class GridViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var livePhotoBadgeImageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    var livePhotoBadgeImage: UIImage! {
        didSet {
            livePhotoBadgeImageView.image = livePhotoBadgeImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        livePhotoBadgeImageView.image = nil
    }
    
    func setup(withPhoto photo: Photo, imageManager: PHCachingImageManager, thumbnailSize: CGSize) {
        if photo.typeValue == .local {
            setupLocal(withPhoto: photo, imageManager: imageManager, thumbnailSize: thumbnailSize)
        } else {
            setupGlobal(withPhoto: photo)
        }
    }
    
    private func setupLocal(withPhoto photo: Photo, imageManager: PHCachingImageManager, thumbnailSize: CGSize) {
        guard let asset = PHAsset.fetchAssets(withLocalIdentifiers: [photo.assetIdentifier!], options: nil).firstObject
            else { return }
        
        // Request an image for the asset from the PHCachingImageManager.
        representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, _ in
            // UIKit may have recycled this cell by the handler's activation time.
            // Set the cell's thumbnail image only if it's still showing the same asset.
            if self?.representedAssetIdentifier == asset.localIdentifier {
                self?.thumbnailImage = image
            }
        })
    }
    
    private func setupGlobal(withPhoto photo: Photo) {
        if let url = photo.filePreview {
            Nuke.loadImage(with: url, into: imageView)
        }
    }
}
