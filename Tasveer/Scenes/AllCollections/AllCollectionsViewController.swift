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
    
    @IBOutlet fileprivate weak var tableView: UITableView!
}

extension AllCollectionsViewController: TableViewDataSourceDelegate {
    func configure(_ cell: AllCollectionCell, for object: AllCollectionsViewController.Object) {
        
    }
    
    func notifyEmptyData(isEmpty: Bool) {
        
    }
}
