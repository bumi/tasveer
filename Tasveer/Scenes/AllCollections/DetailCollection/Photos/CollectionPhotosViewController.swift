//
//  CollectionPhotosViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/7/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import CoreData
import Photos
import PhotosUI

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

final class CollectionPhotosViewController: UICollectionViewController {
    var assetCollection: PHAssetCollection!
    var availableWidth: CGFloat = 0
    var group: Group! {
        didSet {
            setupDataSource()
            collectionView.reloadData()
        }
    }
    
    fileprivate var dataSource: CollectionViewDataSource<CollectionPhotosViewController>?
    
    fileprivate var flowLayout: UICollectionViewFlowLayout!
    
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    fileprivate var previousPreheatRect = CGRect.zero
    
    // MARK: UIViewController / Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(GridViewCell.nib, forCellWithReuseIdentifier: GridViewCell.cellId)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        
        resetCachedAssets()
//        PHPhotoLibrary.shared().register(self)
        
        // FlowLayout
        flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 80, height: 80)
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 0
        
        // Setup Data Source
        setupDataSource()
    }
    
    deinit {
//        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let width = view.bounds.inset(by: view.safeAreaInsets).width
        // Adjust the item size if the available width has changed.
        if availableWidth != width {
            availableWidth = width
            let columnCount = (availableWidth / 80).rounded(.towardZero)
            let itemLength = (availableWidth - columnCount - 1) / columnCount
            flowLayout.itemSize = CGSize(width: itemLength, height: itemLength)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Determine the size of the thumbnails to request from the PHCachingImageManager.
        let scale = UIScreen.main.scale
        let cellSize = flowLayout.itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AssetViewController else { fatalError("Unexpected view controller for segue") }
        guard let collectionViewCell = sender as? UICollectionViewCell else { fatalError("Unexpected sender for segue") }
        
        let indexPath = collectionView.indexPath(for: collectionViewCell)!
//        destination.asset = fetchResult.object(at: indexPath.item)
        destination.assetCollection = assetCollection
    }
    
    private func setupDataSource() {
        // Setup Data Source
        if let moc = PersistentStoreManager.shared.moc, group != nil {
            let request = Photo.sortedFetchRequest
            request.predicate = NSPredicate(format: "group = %@", group)
            request.returnsObjectsAsFaults = false
            let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
            dataSource = CollectionViewDataSource.init(collectionView: collectionView, cellIdentifier: GridViewCell.cellId, fetchedResultsController: frc, delegate: self)
        }
    }
    
    // MARK: UIScrollView
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
    
    // MARK: Asset Caching
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    /// - Tag: UpdateAssets
    fileprivate func updateCachedAssets() {
//        // Update only if the view is visible.
//        guard isViewLoaded && view.window != nil else { return }
//
//        // The window you prepare ahead of time is twice the height of the visible rect.
//        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
//        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
//
//        // Update only if the visible area is significantly different from the last preheated area.
//        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
//        guard delta > view.bounds.height / 3 else { return }
//
//        // Compute the assets to start and stop caching.
//        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
//        let addedAssets = addedRects
//            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
//            .map { indexPath in fetchResult.object(at: indexPath.item) }
//        let removedAssets = removedRects
//            .flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
//            .map { indexPath in fetchResult.object(at: indexPath.item) }
//
//        // Update the assets the PHCachingImageManager is caching.
//        imageManager.startCachingImages(for: addedAssets,
//                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
//        imageManager.stopCachingImages(for: removedAssets,
//                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
//        // Store the computed rectangle for future comparison.
//        previousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
    
    // MARK: UI Actions
    /// - Tag: AddAsset
    @IBAction func addAsset(_ sender: AnyObject?) {
        
        // Create a dummy image of a random solid color and random orientation.
        let size = (arc4random_uniform(2) == 0) ?
            CGSize(width: 400, height: 300) :
            CGSize(width: 300, height: 400)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor(hue: CGFloat(arc4random_uniform(100)) / 100,
                    saturation: 1, brightness: 1, alpha: 1).setFill()
            context.fill(context.format.bounds)
        }
        // Add the asset to the photo library.
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            if let assetCollection = self.assetCollection {
                let addAssetRequest = PHAssetCollectionChangeRequest(for: assetCollection)
                addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
            }
        }, completionHandler: {success, error in
            if !success { print("Error creating the asset: \(String(describing: error))") }
        })
    }
    
}

extension CollectionPhotosViewController: CollectionViewDataSourceDelegate {
    func configure(_ cell: GridViewCell, for object: Photo) {
        cell.setup(withPhoto: object, imageManager: imageManager, thumbnailSize: thumbnailSize)
    }
    
    func notifyEmptyData(isEmpty: Bool) {
        if isEmpty {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
            label.text = "You have no photos."
            label.textAlignment = .center
            collectionView.backgroundView = label
            label.sizeToFit()
        }
        else {
            collectionView.backgroundView = nil
        }
    }
}

