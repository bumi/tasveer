//
//  UIView+identificators.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

extension UIView {
    static var cellId: String {
        return String(describing: self)
    }
    
    static var viewId: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: cellId, bundle: Bundle.main)
    }
}
