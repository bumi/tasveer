//
//  CollectionDetailViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import Photos

enum CollectionDetailType: Int {
    case photos
    case people
}

final class CollectionDetailViewController: UIViewController {
    var collection: Collection?
    
    @IBOutlet fileprivate weak var segmentPicker: UISegmentedControl!
    @IBOutlet fileprivate weak var containerView: UIView!
    
    // Constant title
    private let collectionDetailTitle = "Collection"
    
    private let queue = OperationQueue()
    
    private var people: CollectionPeopleViewController!
    private var photos: CollectionPhotosViewController!
    
    private var collectionObserver: CoreDataContextObserver<Collection>!
    
    private var oldCollectionState: CollectionSyncState = .synced // TODO: Add another case, like .preInit
    
    private var filterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopBar()
        setupChildViewControllers()
        // Initial setup should be for photos
        setupChildViewController(forType: .photos)
        
        // Setup observer of the collection
        setupCollectionObserver()
        
        // Setup title
        addTitle(showActivity: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        openFilterSceneIfNeeded()
    }
    
    deinit {
        collectionObserver?.unobserveAllObjects()
    }
    
    @IBAction fileprivate func segmentSwitched(_ sender: UISegmentedControl) {
        guard let newType = CollectionDetailType(rawValue: sender.selectedSegmentIndex)
            else { fatalError() }
        
        setupChildViewController(forType: newType)
    }
    
    private func setupTopBar() {
        filterButton = UIBarButtonItem.init(image: UIImage(named: "filter_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(openFilterScene))
        navigationItem.rightBarButtonItem = filterButton
        filterButton.isEnabled = (collection?.syncStateValue ?? .none) != .syncing
    }
    
    private func setupChildViewControllers() {
        guard let people = UIStoryboard(name: "Collections", bundle: Bundle.main).instantiateViewController(withIdentifier: "CollectionPeopleViewController") as? CollectionPeopleViewController
            else { return }
        
        let photos = CollectionPhotosViewController.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        people.collection = collection
        photos.collection = collection
        
        self.photos = photos
        self.people = people
    }
    
    private func setupChildViewController(forType type: CollectionDetailType) {
        // Remove current one if there is any
        if let child = children.first {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        // Add new child
        var vc: UIViewController
        
        switch type {
        case .photos:
            vc = photos
        case .people:
            vc = people
        }
        
        addChild(vc)
        vc.didMove(toParent: self)
        containerView.addSubview(vc.view)
        
        // Layout
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    private func setupCollectionObserver() {
        if let collection = collection {
            collectionObserver = CoreDataContextObserver<Collection>.init(context: PersistentStoreManager.shared.moc!)
            collectionObserver.observeObject(object: collection, state: .updated) { [weak self] (updatedCollection, _) in
                DispatchQueue.main.async {
                    guard self?.oldCollectionState != updatedCollection.syncStateValue
                        else { return }
                    self?.oldCollectionState = updatedCollection.syncStateValue
                    self?.updateTitle(collection: updatedCollection)
                }
            }
        }
    }
    
    private func updateTitle(collection: Collection?) {
        guard let collection = collection else { return }
        
        switch collection.syncStateValue {
        case .none, .synced:
            addTitle(showActivity: false)
        case .syncing:
            addTitle(showActivity: true)
        }
    }
    
    private func addTitle(showActivity: Bool) {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        let activitySize: CGSize = showActivity ? CGSize(width: 14, height: 14) : .zero
        activityIndicatorView.frame = CGRect(origin: .zero, size: activitySize)
        activityIndicatorView.color = .black
        activityIndicatorView.startAnimating()
        
        let titleLabel = UILabel()
        titleLabel.text = collectionDetailTitle
        titleLabel.font = UIFont.systemFont(ofSize: 18.0)
        
        let fittingSize = titleLabel.sizeThatFits(CGSize(width: 200.0, height: activityIndicatorView.frame.size.height))
        titleLabel.frame = CGRect(x: activityIndicatorView.frame.origin.x + activityIndicatorView.frame.size.width + 8,
                                  y: activityIndicatorView.frame.origin.y,
                                  width: fittingSize.width,
                                  height: fittingSize.height)
        
        let rect = CGRect(x: (activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width) / 2,
                          y: (activityIndicatorView.frame.size.height) / 2,
                          width: activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width,
                          height: activityIndicatorView.frame.size.height)
        let titleView = UIView(frame: rect)
        if showActivity {
            titleView.addSubview(activityIndicatorView)
        }
        titleView.addSubview(titleLabel)
        titleLabel.sizeToFit()
        
        navigationItem.titleView = titleView
    }
    
    @objc private func applyFilter() {
        if let filter = collection?.filter {
            let operation = ApplyFilterOperation(withCollectionFilter: filter)
            queue.addOperation(operation)
        }
    }
    
    @objc private func openFilterScene() {
        let openScene = OpenFiltersSceneOperation(withCollection: collection) { [weak self] newCollection in
            if self?.collection == nil {
                self?.collection = newCollection
                DispatchQueue.main.sync {
                    self?.photos.collection = newCollection
                    self?.people.collection = newCollection
                    self?.setupCollectionObserver()
                }
            }
            
            self?.applyFilter()
        }
        queue.addOperation(openScene)
    }
    
    @objc private func openFilterSceneIfNeeded() {
        guard collection == nil else { return }
        
        openFilterScene()
    }
}
