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
    
    func layoutCell(with group: Group) {
        
        titleLabel.text = group.title
        contentLabel.text = group.content
        categoryLabel.text = "# \(group.category)"
        
        coverPhotoImage.clipsToBounds = true
        coverPhotoImage.layer.cornerRadius = 15
        coverPhotoImage.loadImage(group.coverPhoto)
    }
}
