//
//  PersonCell.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/7/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class PersonCell: UITableViewCell {
    @IBOutlet fileprivate weak var avatar: UIImageView!
    @IBOutlet fileprivate weak var email: UILabel!
    
    func setup(with email: String) {
        self.email.text = email
    }
}
