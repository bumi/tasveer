//
//  Threads.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 6/23/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

func runOnMain(_ block: () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync(execute: block)
    }
}
