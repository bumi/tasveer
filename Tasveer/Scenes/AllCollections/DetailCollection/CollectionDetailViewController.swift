//
//  CollectionDetailViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class CollectionDetailViewController: UIViewController {
    var group: Group?
    
    private let queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopBar()
    }
    
    private func setupTopBar() {
        let filters = UIBarButtonItem.init(image: UIImage(named: "filter_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(openFilterScene))
        navigationItem.rightBarButtonItem = filters
    }
    
    @objc private func openFilterScene() {
        let openScene = OpenFiltersSceneOperation(withGroup: group)
        queue.addOperation(openScene)
    }
}
