//
//  TextField.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/9/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

class PickerTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
}
