//
//  FiltersViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit

final class FiltersViewController: UITableViewController {
    var group: Group?
    
    @IBOutlet fileprivate weak var albumName: UITextField!
    @IBOutlet fileprivate weak var favoriteSwitch: UISwitch!
    @IBOutlet fileprivate weak var fromTimeframe: UITextField!
    @IBOutlet fileprivate weak var toTimeframe: UITextField!
    @IBOutlet fileprivate weak var saveButton: UIButton!
    
    private let albumPicker: UIPickerView
    private let fromPicker: UIDatePicker
    private let toPicker: UIDatePicker
    private let pickerToolbar: UIToolbar
    
    required init?(coder aDecoder: NSCoder) {
        albumPicker = UIPickerView(frame: CGRect.zero)
        fromPicker = UIDatePicker(frame: CGRect.zero)
        toPicker = UIDatePicker(frame: CGRect.zero)
        pickerToolbar = UIToolbar(frame: CGRect.zero)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickers()
    }
    
    @IBAction fileprivate func save(_ sender: UIButton!) {
        
    }
    
    @IBAction fileprivate func switchFavorite(_ sender: UISwitch) {
        
    }
    
    private func setupPickers() {
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction(_:)))
        pickerToolbar.items = [done]
        
        setupPicker(albumPicker, forTextfield: albumName)
        setupPicker(fromPicker, forTextfield: fromTimeframe)
        setupPicker(toPicker, forTextfield: toTimeframe)
    }
    
    private func setupPicker(_ picker: UIView, forTextfield textfield: UITextField) {
        picker.translatesAutoresizingMaskIntoConstraints = false
        textfield.inputView = picker
        textfield.inputAccessoryView = pickerToolbar
        picker.sizeToFit()
        pickerToolbar.sizeToFit()
    }
    
    @objc private func doneAction(_ sender: UIBarButtonItem) {
        view.firstResponder?.resignFirstResponder()
    }
    
//    private func togglePickerAppearance(_ picker: UIPickerView) {
//        guard let top = picker.constraints.filter({ $0.firstAnchor == picker.topAnchor }).first else { return }
//        UIView.animate(withDuration: 0.3) {
//            top.constant = top.constant == 0 ? -picker.frame.height : 0
//        }
//    }
}
