//
//  ButtonCell.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/7/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class ButtonCell: UITableViewCell {
    @IBOutlet fileprivate weak var button: UIButton!
    var didTap: (() -> Void)?
    
    @IBAction fileprivate func buttonDidTap(_ sender: UIButton!) {
        didTap?()
    }
}
