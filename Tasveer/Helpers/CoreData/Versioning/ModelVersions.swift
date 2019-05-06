//
//  ModelVersions.swift
//  BoweryRes
//
//  Created by Haik Ampardjian on 4/20/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import CoreData
import UIKit

enum Version: String {
    case version1 = "Tasveer"
    case version2 = "Tasveer v2"
}

extension Version: ModelVersion {
    static var all: [Version] {
        return [.version2, .version1]
    }
    
    static var current: Version { return .version2 }
    
    var name: String { return rawValue }
    var modelBundle: Bundle { return Bundle(for: Tasveer.self) }
    var modelDirectoryName: String { return "Tasveer.momd" }
    
    var successor: Version? {
        switch self {
        case .version1: return .version2
        default: return nil
        }
    }
    
    func mappingModelsToSuccessor() -> [NSMappingModel]? {
        switch self {
        case .version1:
            let mapping = try! NSMappingModel.inferredMappingModel(forSourceModel: managedObjectModel(),
                                                                   destinationModel: successor!.managedObjectModel())
            return [mapping]
        default:
            guard let mapping = mappingModelToSuccessor() else { return nil }
            return [mapping]
        }
    }
}

public final class Tasveer: NSManagedObject {}
