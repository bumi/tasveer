//
//  PickAlbumViewController.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/9/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import Photos

class PickAlbumViewModel {
    let userCollection: PHFetchResult<PHCollection>
    let smartAlbum: PHFetchResult<PHAssetCollection>
    
    init(userCollection: PHFetchResult<PHCollection>, smartAlbum: PHFetchResult<PHAssetCollection>) {
        self.userCollection = userCollection
        self.smartAlbum = smartAlbum
    }
}

final class PickAlbumViewController: UITableViewController {
    var pickModel: PickAlbumViewModel!
    var filtersModel: FiltersModel?
    
    private let pickAlbumCellId = "pickAlbumCellId"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return pickModel.userCollection.count
        case 2:
            return pickModel.smartAlbum.count
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: pickAlbumCellId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: pickAlbumCellId)
        }
        
        let cellTitle: String
        switch indexPath.section {
        case 0:
            cellTitle = "All Photos"
        case 1:
            cellTitle = pickModel.userCollection.object(at: indexPath.row).localizedTitle ?? ""
        case 2:
            cellTitle = pickModel.smartAlbum.object(at: indexPath.row).localizedTitle ?? ""
        default:
            fatalError()
        }
        
        cell?.textLabel?.text = cellTitle
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "User Album"
        case 2:
            return "Smart Album"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type: String
        let name: String?
        let id: String?
        
        switch indexPath.section {
        case 0:
            type = AlbumName.allPhotosType
            name = nil
            id = nil
        case 1:
            type = AlbumName.userAlbumType
            name = pickModel.userCollection.object(at: indexPath.row).localizedTitle
            id = pickModel.userCollection.object(at: indexPath.row).localIdentifier
        case 2:
            type = AlbumName.smartAlbumType
            name = pickModel.smartAlbum.object(at: indexPath.row).localizedTitle
            id = pickModel.smartAlbum.object(at: indexPath.row).localIdentifier
        default:
            fatalError()
        }
        
        let albumName = AlbumName(withType: type, name: name, id: id)
        filtersModel?.pickedAlbum = albumName
        
        // Pop back
        navigationController?.popViewController(animated: true)
    }
}
