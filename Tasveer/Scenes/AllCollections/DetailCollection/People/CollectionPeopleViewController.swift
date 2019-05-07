//
//  CollectionPeopleViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/7/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class CollectionPeopleViewController: UIViewController {
    var group: Group?
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    private var model: CollectionPeopleModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = CollectionPeopleModel(withGroup: group)
    }
    
    private func setupTableView() {
    }
}

extension CollectionPeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return model.emails.count
        case 1:
            return 1
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>, for: <#T##IndexPath#>)
        case 1:
        default:
            fatalError()
        }
    }
}
