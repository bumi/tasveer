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
    private let filter: GroupFilter
    
    init(withGroup group: Group?, filter: GroupFilter) {
        self.group = group
        self.filter = filter
        
        super.init()
        
        name = "Open Filters Scene from All Collections Scene"
    }
    
    override func execute() {
        DispatchQueue.main.async {
            self.vc = UIStoryboard(name: "Collections", bundle: Bundle.main).instantiateViewController(withIdentifier: "FiltersViewController") as? FiltersViewController
            self.vc?.group = self.group
            self.vc?.filter = self.filter
            
            guard let nextScene = self.vc else { return }
            
            AppDelegateManager.currentNavigationController?.pushViewController(nextScene, animated: true)
            self.finish()
        }
    }
}
