//
//  User.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import CoreData

final class User: NSManagedObject {
    @NSManaged fileprivate(set) var name: String?
    @NSManaged fileprivate(set) var email: String?
    @NSManaged fileprivate(set) var deviceId: String
    @NSManaged fileprivate(set) var identifier: String
    
    @NSManaged fileprivate(set) var group: Group
}
