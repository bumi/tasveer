//
//  OpenFiltersSceneOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class OpenFiltersSceneOperation: Operation {
    private var vc: FiltersViewController?
    private let collection: Collection?
    private let savedCallback: (Collection) -> Void
    
    init(withCollection collection: Collection?, savedCallback: @escaping (Collection) -> Void) {
        self.collection = collection
        self.savedCallback = savedCallback
        
        super.init()
        
        name = "Open Filters Scene from All Collections Scene"
    }
    
    override func execute() {
        DispatchQueue.main.async {
            self.vc = UIStoryboard(name: "Collections", bundle: Bundle.main).instantiateViewController(withIdentifier: "FiltersViewController") as? FiltersViewController
            self.vc?.collection = self.collection
            self.vc?.savedCallback = self.savedCallback
            
            guard let nextScene = self.vc else { return }
            
            AppDelegateManager.currentNavigationController?.pushViewController(nextScene, animated: true)
            self.finish()
        }
    }
    
    override func finished(_ errors: [NSError]) {
        debugPrint("COMPLETED: \(String(describing: name))")
        
        super.finished(errors)
    }
}
