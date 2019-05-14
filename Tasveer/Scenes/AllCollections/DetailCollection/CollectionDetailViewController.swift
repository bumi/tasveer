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
    var group: Group?
    
    @IBOutlet fileprivate weak var segmentPicker: UISegmentedControl!
    @IBOutlet fileprivate weak var containerView: UIView!
    
    private let queue = OperationQueue()
    
    private var people: CollectionPeopleViewController!
    private var photos: CollectionPhotosViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollection()
        setupTopBar()
        setupChildViewControllers()
        // Initial setup should be for photos
        setupChildViewController(forType: .photos)
        
        filterIsUpdated()
        
        // Observe filter updates
        NotificationCenter.default.addObserver(self, selector: #selector(filterIsUpdated), name: NSNotification.Name(rawValue: GroupFilterValueIsChangedKey), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let filter = group?.filter {
            let operation = FetchPhotosByFilterOperation(withGroupFilter: filter)
            operation.addCompletionBlock { [weak self] in
                DispatchQueue.main.async {
                    if let fetchResult = operation.fetchResult {
                        self?.photos.fetchResult = fetchResult
                    }
                }
            }
            
            queue.addOperation(operation)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: GroupFilterValueIsChangedKey), object: nil)
    }
    
    @IBAction fileprivate func segmentSwitched(_ sender: UISegmentedControl) {
        guard let newType = CollectionDetailType(rawValue: sender.selectedSegmentIndex)
            else { fatalError() }
        
        setupChildViewController(forType: newType)
    }
    
    private func setupCollection() {
        if group == nil, let moc = PersistentStoreManager.shared.moc {
            moc.performChangesAndWait { [unowned self] in
                self.group = Group.insertNew(into: moc)
            }
        }
    }
    
    private func setupTopBar() {
        let filters = UIBarButtonItem.init(image: UIImage(named: "filter_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(openFilterScene))
        navigationItem.rightBarButtonItem = filters
    }
    
    private func setupChildViewControllers() {
        guard let people = UIStoryboard(name: "Collections", bundle: Bundle.main).instantiateViewController(withIdentifier: "CollectionPeopleViewController") as? CollectionPeopleViewController
            else { return }
        
        let photos = CollectionPhotosViewController.init(collectionViewLayout: UICollectionViewFlowLayout())
        
        people.group = group
        
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
    
    @objc private func openFilterScene() {
        let openScene = OpenFiltersSceneOperation(withGroup: group, filter: group!.filter)
        queue.addOperation(openScene)
    }
    
    @objc private func filterIsUpdated() {
        let operation = FetchPhotosByFilterOperation(withGroupFilter: group!.filter)
        queue.addOperation(operation)
    }
}
