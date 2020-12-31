//
//  FavoriteMonthCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/15.
//

import UIKit

class UserFavoriteCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoCountLabel: UILabel!
    
    func layoutCell(with favorite: Favorite) {
        
        monthLabel.text = favorite.month
        photoCountLabel.text = "\(favorite.dailys.count)"
        photoImage.loadImage(favorite.dailys.first?.photo?.url)
        photoImage.clipsToBounds = true
        photoImage.layer.cornerRadius = 15
    }
}
