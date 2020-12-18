//
//  ChallengeCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/17.
//

import UIKit

class ChallengeCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func layoutCell(with challenge: Challenge) {
        
        avatarImage.loadImage(challenge.avatar)
        avatarImage.layer.cornerRadius = 15
        
        contentLabel.text = challenge.content
        dateLabel.text = challenge.date
    }
}
