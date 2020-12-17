//
//  GroupCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/14.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var coverPhotoImage: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var ownerAvatarImage: UIImageView!
    
    func layoutCell(with group: Group, memberCount: Int) {
        
        titleLabel.text = group.title
        contentLabel.text = group.content
        categoryLabel.text = "# \(group.category)"
        memberCountLabel.text = "\(memberCount)"
        ownerLabel.text = group.owner.name
        
        ownerAvatarImage.loadImage(group.owner.avatar)
        coverPhotoImage.loadImage(group.coverPhoto)
        ownerAvatarImage.clipsToBounds = true
        coverPhotoImage.clipsToBounds = true
        ownerAvatarImage.layer.cornerRadius = ownerAvatarImage.frame.height / 2
        coverPhotoImage.layer.cornerRadius = 15
    }
}
