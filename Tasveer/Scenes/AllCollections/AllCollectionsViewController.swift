//
//  AllCollectionsViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import MaterialComponents

final class AllCollectionsViewController: UIViewController {
    private var dataSource: TableViewDataSource<AllCollectionsViewController>?
    private var floatingButton: MDCFloatingButton?
    private let queue = OperationQueue()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupFloatingButton()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60.0
        
        tableView.register(AllCollectionCell.nib, forCellReuseIdentifier: AllCollectionCell.cellId)
        
        // FIXME: setup datasource
    }
    
    private func setupFloatingButton() {
        let plusImage = UIImage(named: "add")
        floatingButton = MDCFloatingButton()
        floatingButton?.setImage(plusImage, for: .normal)
        floatingButton?.backgroundColor = UIColor.darkGray
        floatingButton?.translatesAutoresizingMaskIntoConstraints = false
        floatingButton?.addTarget(self, action: #selector(showCreateNewGroup), for: .touchUpInside)
        
        view.addSubview(floatingButton!)
        
        floatingButton?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        floatingButton?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc private func showCreateNewGroup() {
        
    }
}

extension AllCollectionsViewController: TableViewDataSourceDelegate {
    func configure(_ cell: AllCollectionCell, for object: Group) {
        
    }
    
    func notifyEmptyData(isEmpty: Bool) {
        
    }
}
