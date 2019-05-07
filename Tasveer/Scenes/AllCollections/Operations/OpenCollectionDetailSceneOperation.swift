//
//  OpenCollectionDetailSceneOperation.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class OpenCollectionDetailSceneOperation: Operation {
    private var vc: CollectionDetailViewController?
    private let group: Group?
    
    init(withGroup group: Group?) {
        self.group = group
        
        super.init()
        
        name = "Open Filters Scene from All Collections Scene"
    }
    
    override func execute() {
        DispatchQueue.main.async {
            self.vc = UIStoryboard(name: "Collections", bundle: Bundle.main).instantiateViewController(withIdentifier: "CollectionDetailViewController") as? CollectionDetailViewController
            self.vc?.group = self.group
            
            guard let nextScene = self.vc else { return }
            
            AppDelegateManager.currentNavigationController?.pushViewController(nextScene, animated: true)
            self.finish()
        }
    }
}