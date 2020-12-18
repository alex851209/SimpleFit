//
//  InvitationCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/18.
//

import UIKit

class InvitationCell: UITableViewCell {
    
    @IBOutlet weak var acceptButton: UIButton!
    
    func layoutCel() {
        
        acceptButton.applyBorder()
    }
}
