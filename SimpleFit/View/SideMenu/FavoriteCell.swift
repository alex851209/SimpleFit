//
//  PhotoCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit
import Gemini

class FavoriteCell: GeminiCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    func layoutCell(with image: UIImage) {
        
        layer.cornerRadius = 25
        applyShadow()
        
        photoImage.image = image
        photoImage.tintColor = .systemGray
        
        dateLabel.text = "2020-12-03"
        dateLabel.applyBorder()
        
        weightLabel.text = "63.3"
        weightLabel.applyBorder()
    }
}
