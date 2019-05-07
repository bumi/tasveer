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
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(PersonCell.nib, forCellReuseIdentifier: PersonCell.cellId)
        tableView.register(ButtonCell.nib, forCellReuseIdentifier: ButtonCell.cellId)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.cellId, for: indexPath) as? PersonCell
                else { fatalError() }
            
            let viewModel = model.emails[indexPath.row]
            cell.setup(with: viewModel)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.cellId, for: indexPath) as? ButtonCell
                else { fatalError() }
            
            cell.setup(withTitle: "Invite")
            cell.didTap = { [weak self] in
                self?.promptInvite()
            }
            
            return cell
        default:
            fatalError()
        }
    }
    
    private func promptInvite() {
        let alert = UIAlertController(title: "INVITE", message: "Please enter email of person to invite", preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Email"
        }
        alert.addAction(UIAlertAction(title: "Invite", style: .default, handler: { [weak self, weak alert](_) in
            if let email = alert?.textFields?.first?.text {
                self?.invitePerson(withEmail: email)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    private func invitePerson(withEmail email: String) {
        
    }
}
