//
//  AllCollectionCell.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class AllCollectionCell: UITableViewCell {
    @IBOutlet fileprivate weak var collectionName: UILabel!
    @IBOutlet fileprivate weak var photoCount: UILabel!
    @IBOutlet fileprivate weak var participantCount: UILabel!
    
    func setup(with group: Group) {
        collectionName.text = group.name
        photoCount.text = "100" // FIXME: fetch real data
        participantCount.text = String(group.users.count)
    }
}
