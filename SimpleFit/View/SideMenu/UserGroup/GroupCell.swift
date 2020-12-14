//
//  GroupCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/14.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupPhotoImage: UIImageView!
    
    func layoutCell() {
        
        groupPhotoImage.applyBorder()
        groupPhotoImage.layer.cornerRadius = 10
    }
}
