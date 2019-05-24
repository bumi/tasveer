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
    private var collection: Group!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tapIconGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped(_:)))
        icon.addGestureRecognizer(tapIconGesture)
        
        tapResumeGesture = UITapGestureRecognizer(target: self, action: #selector(resumeTapped(_:)))
        resumeImage.addGestureRecognizer(tapResumeGesture)
    }
    
    func setup(with group: Group) {
        collectionName.text = group.name
        photoCount.text = String(group.photos?.count ?? 0)
        participantCount.text = String(group.users.count)
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
