//
//  RouterErrors.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import Foundation

enum RouterError: Error {
    case noBaseURL
}

extension RouterError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .noBaseURL:
            return "Base URL is on wrong format!"
        }
    }
}
