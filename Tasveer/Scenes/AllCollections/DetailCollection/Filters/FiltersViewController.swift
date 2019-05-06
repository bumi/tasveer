//
//  FiltersViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class FiltersViewController: UIViewController {
    var group: Group?
    
    @IBOutlet fileprivate weak var albumName: UILabel!
    @IBOutlet fileprivate weak var favoriteSwitch: UISwitch!
    @IBOutlet fileprivate weak var fromTimeframe: UILabel!
    @IBOutlet fileprivate weak var toTimeframe: UILabel!
    @IBOutlet fileprivate weak var saveButton: UIButton!
    
    @IBAction fileprivate func save(_ sender: UIButton!) {
        
    }
    
}
