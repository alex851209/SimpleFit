//
//  ReplyCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/14.
//

import UIKit

class ReplyCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    
    func layoutCell() {
        
        avatarImage.applyBorder()
        avatarImage.layer.borderWidth = 2
    }
}
