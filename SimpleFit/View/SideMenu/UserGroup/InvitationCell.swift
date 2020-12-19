//
//  InvitationCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/18.
//

import UIKit

class InvitationCell: UITableViewCell {
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var inviterImage: UIImageView!
    @IBOutlet weak var inviterNameLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    func layoutCell(with invitation: Invitation) {
        
        acceptButton.applyBorder()
        inviterImage.layer.cornerRadius = inviterImage.frame.height / 2
        
        inviterNameLabel.text = invitation.inviter.name
        inviterImage.loadImage(invitation.inviter.avatar)
        groupNameLabel.text = invitation.name
    }
}
