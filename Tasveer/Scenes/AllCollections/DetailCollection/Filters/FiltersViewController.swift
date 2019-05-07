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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction fileprivate func switchFavorite(_ sender: UISwitch) {
        
    }
    
    private func setupPickers() {
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction(_:)))
        pickerToolbar.items = [done]
        
        setupPicker(albumPicker, forTextfield: albumName)
        setupDatePicker(fromPicker, forTextfield: fromTimeframe)
        setupDatePicker(toPicker, forTextfield: toTimeframe)
    }
    
    private func setupPicker(_ picker: UIPickerView, forTextfield textfield: UITextField) {
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        textfield.inputView = picker
        textfield.inputAccessoryView = pickerToolbar
        picker.sizeToFit()
        pickerToolbar.sizeToFit()
    }
    
    private func setupDatePicker(_ picker: UIDatePicker, forTextfield textfield: UITextField) {
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .dateAndTime
        picker.addTarget(self, action: #selector(dateIsPicked(_:)), for: .valueChanged)
        textfield.inputView = picker
        textfield.inputAccessoryView = pickerToolbar
        picker.sizeToFit()
        pickerToolbar.sizeToFit()
    }
    
    @objc private func doneAction(_ sender: UIBarButtonItem) {
        view.firstResponder?.resignFirstResponder()
    }
    
    @objc private func dateIsPicked(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        switch sender {
        case fromPicker:
            fromTimeframe.text = formatter.string(from: sender.date)
        case toPicker:
            toTimeframe.text = formatter.string(from: sender.date)
        default:
            break
        }
    }
    
//    private func togglePickerAppearance(_ picker: UIPickerView) {
//        guard let top = picker.constraints.filter({ $0.firstAnchor == picker.topAnchor }).first else { return }
//        UIView.animate(withDuration: 0.3) {
//            top.constant = top.constant == 0 ? -picker.frame.height : 0
//        }
//    }
}

extension FiltersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%d", (row + 1))
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        albumName.text = String(format: "%d", (row + 1))
    }
}
