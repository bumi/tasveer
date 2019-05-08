//
//  CollectionDetailViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

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
        
        setupTopBar()
        setupChildViewControllers()
        // Initial setup should be for photos
        setupChildViewController(forType: .photos)
        
        // Test photo fetching
        let operation = FetchPhotosByFilterOperation()
        queue.addOperation(operation)
    }
    
    @IBAction fileprivate func segmentSwitched(_ sender: UISegmentedControl) {
        guard let newType = CollectionDetailType(rawValue: sender.selectedSegmentIndex)
            else { fatalError() }
        
        setupChildViewController(forType: newType)
    }
    
    private func setupTopBar() {
        let filters = UIBarButtonItem.init(image: UIImage(named: "filter_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(openFilterScene))
        navigationItem.rightBarButtonItem = filters
    }
    
    private func setupChildViewControllers() {
        guard let photos = UIStoryboard(name: "Collections", bundle: Bundle.main).instantiateViewController(withIdentifier: "CollectionPhotosViewController") as? CollectionPhotosViewController,
            let people = UIStoryboard(name: "Collections", bundle: Bundle.main).instantiateViewController(withIdentifier: "CollectionPeopleViewController") as? CollectionPeopleViewController
            else { return }
        
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
        let openScene = OpenFiltersSceneOperation(withGroup: group)
        queue.addOperation(openScene)
    }
}
