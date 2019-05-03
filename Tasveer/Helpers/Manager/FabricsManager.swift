//
//  FabricsManager.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

struct FabricsManager {
    static func setup() {
        Fabric.with([Crashlytics.self])
    }
}
