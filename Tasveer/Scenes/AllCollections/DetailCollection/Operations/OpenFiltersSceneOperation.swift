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
    private let group: Group?
    private let savedCallback: (Group) -> Void
    
    init(withGroup group: Group?, savedCallback: @escaping (Group) -> Void) {
        self.group = group
        self.savedCallback = savedCallback
        
        super.init()
        
        name = "Open Filters Scene from All Collections Scene"
    }
    
    override func execute() {
        DispatchQueue.main.async {
            self.vc = UIStoryboard(name: "Collections", bundle: Bundle.main).instantiateViewController(withIdentifier: "FiltersViewController") as? FiltersViewController
            self.vc?.group = self.group
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
