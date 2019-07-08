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
    var collection: Collection? {
        didSet {
            if let newCollection = collection {
                filterModel = FiltersModel(with: newCollection.filter)
            }
        }
    }
    
    var filterModel = FiltersModel()
    
    // Callback to handle new collection created
    var savedCallback: ((Collection) -> Void)?
    
    @IBOutlet fileprivate weak var collectionName: UITextField!
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
        setupNameTextField()
        validateNewFilter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    @IBAction fileprivate func save(_ sender: UIButton!) {
        if collection == nil {
            saveNewFilter()
        } else {
            saveExistingFilter()
        }
    }
    
    @IBAction fileprivate func switchFavorite(_ sender: UISwitch) {
        filterModel.isFavorite = sender.isOn
    }
    
    private func setupUI() {
        albumName.text = filterModel.pickedAlbum.title
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
    
    private func setupNameTextField() {
        collectionName.returnKeyType = .done
        collectionName.clearButtonMode = .whileEditing
        collectionName.text = collection?.name
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
    
    private func validateNewFilter() {
        guard collection == nil
            else { return }
        
        saveTimeframe(forPicker: fromPicker, dueDate: Date())
    }
    
    // Save when Collection were existing already
    private func saveExistingFilter() {
        guard preSaveValidate() else { return }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let operation = SaveAndUpdateExistingFilterOperation(filterModel: filterModel, and: collection!)
        operation.addCompletionBlock { [weak self] in
            self?.savedCallback?(self!.collection!)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self!.view, animated: true)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        queue.addOperation(operation)
    }
    
    // Save when Collection is created now
    private func saveNewFilter() {
        guard preSaveValidate() else { return }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let operation = CreateAndSaveCollectionOperation(filterModel: filterModel) { [weak self] (collection) in
            self?.savedCallback?(collection)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self!.view, animated: true)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        queue.addOperation(operation)
    }
    
    private func preSaveValidate() -> Bool {
        if let error = filterModel.validate() {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            navigationController?.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    // Call this either initially on load or when datePicker is picked
    private func saveTimeframe(forPicker picker: UIDatePicker, dueDate date: Date) {
        let formatter = DateFormatter.filterStyle
        
        switch picker {
        case fromPicker:
            fromTimeframe.text = formatter.string(from: date)
            filterModel.fromDate = date
        case toPicker:
            toTimeframe.text = formatter.string(from: date)
            filterModel.toDate = date
        default:
            break
        }
    }
    
    @objc private func doneAction(_ sender: UIBarButtonItem) {
        view.firstResponder?.resignFirstResponder()
    }
    
    @objc private func dateIsPicked(_ sender: UIDatePicker) {
        saveTimeframe(forPicker: sender, dueDate: sender.date)
    }
    
    @objc private func cancel(_ sender: UIBarButtonItem) {
        /// If new collection is canceled, then pop to root vc
        if collection == nil {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func collectionNameIsSet(_ textfield: UITextField) {
        guard let collectionName = textfield.text, !collectionName.isEmpty
            else { return }
        
        let moc = PersistentStoreManager.shared.moc
        moc?.performChanges { [weak self] in
            self?.collection?.updateName(text: collectionName)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let vc = PickAlbumViewController(style: .plain)
            vc.pickModel = pickModel
            vc.filtersModel = filterModel
            navigationController?.pushViewController(vc, animated: true)
        }
    }
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

extension FiltersViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case fromTimeframe:
            filterModel.fromDate = nil
        case toTimeframe:
            filterModel.toDate = nil
        default:
            break
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count > 0 else {
            return true
        }
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        filterModel.name = prospectiveText
        
        return true
    }
}
