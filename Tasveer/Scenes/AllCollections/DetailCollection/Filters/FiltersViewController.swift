//
//  FiltersViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/6/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import MBProgressHUD
import Photos

final class FiltersViewController: UITableViewController {
    var group: Group? {
        didSet {
            if let newGroup = group {
                filterModel = FiltersModel(with: newGroup.filter)
            }
        }
    }
    
    var filterModel: FiltersModel!
    
    @IBOutlet fileprivate weak var albumName: PickerTextField!
    @IBOutlet fileprivate weak var favoriteSwitch: UISwitch!
    @IBOutlet fileprivate weak var fromTimeframe: PickerTextField!
    @IBOutlet fileprivate weak var toTimeframe: PickerTextField!
    @IBOutlet fileprivate weak var saveButton: UIButton!
    
    private let albumPicker: UIPickerView
    private let fromPicker: UIDatePicker
    private let toPicker: UIDatePicker
    private let pickerToolbar: UIToolbar
    
    private let queue = OperationQueue()
    
    private var pickModel: PickAlbumViewModel?
    
    // Store album names
    private var albumNames: [String] = []
    
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
        fetchAlbums()
        setupPickModel()
        setupCancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    @IBAction fileprivate func save(_ sender: UIButton!) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction fileprivate func switchFavorite(_ sender: UISwitch) {
        
    }
    
    private func setupUI() {
        albumName.text = filterModel?.pickedAlbum.title
        favoriteSwitch.isOn = filterModel.isFavorite
        
        if let fromDate = filterModel.fromDate {
            fromTimeframe.text = DateFormatter.filterStyle.string(from: fromDate)
        }
        
        if let toDate = filterModel.toDate {
            toTimeframe.text = DateFormatter.filterStyle.string(from: toDate)
        }
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
    
    private func fetchAlbums() {
        MBProgressHUD.showAdded(to: view, animated: true)
        let operation = FetchAlbumNamesOperation { [weak self] (titles) in
            self?.albumNames = titles
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self!.view, animated: true)
            }
        }
        
        queue.addOperation(operation)
    }
    
    private func setupPickModel() {
        let userCollection = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        pickModel = PickAlbumViewModel(userCollection: userCollection, smartAlbum: smartAlbum)
    }
    
    private func setupCancel() {
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        navigationItem.leftBarButtonItem = cancel
    }
    
    @objc private func doneAction(_ sender: UIBarButtonItem) {
        view.firstResponder?.resignFirstResponder()
    }
    
    @objc private func dateIsPicked(_ sender: UIDatePicker) {
        let formatter = DateFormatter.filterStyle
        
        switch sender {
        case fromPicker:
            fromTimeframe.text = formatter.string(from: sender.date)
        case toPicker:
            toTimeframe.text = formatter.string(from: sender.date)
        default:
            break
        }
    }
    
    @objc private func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let vc = PickAlbumViewController(style: .plain)
            vc.pickModel = pickModel
            vc.filtersModel = filterModel
            navigationController?.pushViewController(vc, animated: true)
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
        return albumNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return albumNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        albumName.text = albumNames[row]
    }
}
