//
//  GoalCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/8.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var beginDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var beginWeight: UILabel!
    @IBOutlet weak var endWeight: UILabel!
    
    func layoutCell() {
        
        beginWeight.applyBorder()
        beginWeight.layer.borderWidth = 0
        endWeight.applyBorder()
        endWeight.layer.borderWidth = 0
    }
}
