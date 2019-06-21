//
//  AllCollectionsViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import CoreData
import MaterialComponents

final class AllCollectionsViewController: UIViewController {
    private var dataSource: TableViewDataSource<AllCollectionsViewController>?
    private var floatingButton: MDCFloatingButton?
    private let queue = OperationQueue()
    private let model = AllCollectionsViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupFloatingButton()
        
        // Fetch new photos on launch if needed
        fetchNewPhotosIfNeeded(forObjects: dataSource?.fetchedResultsController.fetchedObjects)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("NewCollectionInserted"), object: nil, queue: nil) { [weak self] (note) in
            if let collection = note.userInfo?["insertedCollection"] as? Collection {
                DispatchQueue.main.async {
                    self?.startUploading(for: collection)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupUploadsIfNeeded(forObjects: dataSource?.fetchedResultsController.fetchedObjects)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("NewCollectionInserted"), object: nil)
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60.0
        
        tableView.register(AllCollectionCell.nib, forCellReuseIdentifier: AllCollectionCell.cellId)
        
        guard let moc = PersistentStoreManager.shared.moc
            else { return }
        let request = Collection.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource.init(tableView: tableView,
                                              cellIdentifier: AllCollectionCell.cellId,
                                              fetchedResultsController: frc,
                                              delegate: self)
    }
    
    private func fetchNewPhotosIfNeeded(forObjects objects: [Collection]?) {
        guard let objects = objects else { return }
        model.fetchNewPhotosIfNeeded(for: objects)
    }
    
    private func setupUploadsIfNeeded(forObjects objects: [Collection]?) {
        guard let objects = objects else { return }
        model.startUploadIfNeeded(for: objects)
    }
    
    private func setupFloatingButton() {
        let plusImage = UIImage(named: "add")
        floatingButton = MDCFloatingButton()
        floatingButton?.setImage(plusImage, for: .normal)
        floatingButton?.backgroundColor = UIColor.darkGray
        floatingButton?.translatesAutoresizingMaskIntoConstraints = false
        floatingButton?.addTarget(self, action: #selector(showCreateNewCollection), for: .touchUpInside)
        
        view.addSubview(floatingButton!)
        
        floatingButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        floatingButton?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    private func showCollection(collection: Collection?) {
        let openScene = OpenCollectionDetailSceneOperation(withCollection: collection)
        queue.addOperation(openScene)
    }
    
    @objc private func showCreateNewCollection() {
        showCollection(collection: nil)
    }
}

extension AllCollectionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let collection = dataSource?.objectAtIndexPath(indexPath)
        showCollection(collection: collection)
    }
}

extension AllCollectionsViewController: TableViewDataSourceDelegate {
    func configure(_ cell: AllCollectionCell, for object: Collection) {
        cell.setup(with: object)
        
        cell.didTapResume = { [weak self, weak object] in
            self?.startUploading(for: object)
        }
    }
    
    func notifyEmptyData(isEmpty: Bool) {
        if isEmpty {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.text = "You have no collections."
            label.textAlignment = .center
            tableView.backgroundView = label
            label.sizeToFit()
        }
        else {
            tableView.backgroundView = nil
        }
    }
}

extension AllCollectionsViewController {
    private func startUploading(for collection: Collection?) {
        model.startUpload(for: collection)
    }
}
