//
//  AllCollectionCell.swift
//  Tasveer
//
//  Created by Haik Ampardjian on 5/3/19.
//  Copyright © 2019 Haik Ampardjian. All rights reserved.
//

import UIKit
import MBCircularProgressBar

final class AllCollectionCell: UITableViewCell {
    var didTapIcon: (() -> Void)?
    var didTapResume: (() -> Void)?
    
    @IBOutlet fileprivate weak var collectionName: UILabel!
    @IBOutlet fileprivate weak var photoCount: UILabel!
    @IBOutlet fileprivate weak var participantCount: UILabel!
    @IBOutlet fileprivate weak var icon: UIImageView!
    @IBOutlet fileprivate weak var activity: MBCircularProgressBarView!
    @IBOutlet fileprivate weak var resumeImage: UIImageView!
    
    private var tapIconGesture: UITapGestureRecognizer!
    private var tapResumeGesture: UITapGestureRecognizer!
    private var collection: Collection!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tapIconGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped(_:)))
        icon.addGestureRecognizer(tapIconGesture)
        
        tapResumeGesture = UITapGestureRecognizer(target: self, action: #selector(resumeTapped(_:)))
        resumeImage.addGestureRecognizer(tapResumeGesture)
    }
    
    func setup(with collection: Collection) {
        self.collection = collection
        
        backgroundColor = collection.syncStateValue == .synced ? CollectionColors.green : UIColor.white
        
        if collection.syncStateValue == .syncing {
            activity.isHidden = collection.task?.isPaused ?? false
            activity.value = CGFloat(collection.uploadProgress) * 100
            resumeImage.isHidden = !(collection.task?.isPaused ?? false)
        } else {
            activity.isHidden = true
            resumeImage.isHidden = true
        }
        
        let image = UIImage(named: (collection.syncStateValue == .synced) ? "round_check" : "cloud_icon")
        icon.image = image
        icon.alpha = (collection.syncStateValue == .syncing) ? 0.0 : 1.0
        
        collectionName.text = collection.name
        photoCount.text = String(collection.photos?.count ?? 0)
        participantCount.text = String(collection.users.count)
    }
    
    @objc private func iconTapped(_ sender: UITapGestureRecognizer) {
        guard collection.syncStateValue == .none else { return }
        didTapIcon?()
    }
    
    @objc private func resumeTapped(_ sender: UITapGestureRecognizer) {
        guard let isPaused = collection.task?.isPaused, isPaused
            else { return }
        didTapResume?()
    }
}
