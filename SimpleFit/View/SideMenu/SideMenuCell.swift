//
//  SideMenuCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import UIKit
import SideMenu

class SideMenuCell: UITableViewVibrantCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    func layoutCell(with item: SideMenuItem) {
        
        titleLabel.text = item.title
        iconImage.image = item.image
    }
}
