//
//  FavoriteCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/16.
//

import UIKit
import Gemini

class MonthFavoriteCell: GeminiCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var weightNumberLabel: UILabel!
    @IBOutlet var weightLabels: [UILabel]!
    
    func layoutCell(with daily: DailyData) {
        
        guard let weight = daily.weight else { return }
        let weightString = String(describing: weight)
        weightNumberLabel.text = weightString
        weightNumberLabel.applyShadow()
        weightNumberLabel.layer.shadowOpacity = 0.2
        weightNumberLabel.layer.shadowOffset = CGSize(width: 2, height: 5)
        weightLabels.forEach {
            
            $0.applyShadow()
            $0.layer.shadowOffset = CGSize(width: 2, height: 5)
            $0.layer.shadowOpacity = 0.2
        }
        
        photoImage.loadImage(daily.photo?.url)
        photoImage.applyShadow()
        photoImage.layer.shadowOffset = CGSize(width: 5, height: 10)
        photoImage.layer.shadowOpacity = 0.2
    }
}
