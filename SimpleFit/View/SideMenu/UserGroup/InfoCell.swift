//
//  InfoCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/17.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverPhotoButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBAction func coverPhotoButtonDidTap(_ sender: Any) { showPhotoAlert() }
    
    func layoutCell(with group: Group) {
        
        titleLabel.text = group.title
        contentLabel.text = group.content
        
        coverPhotoButton.clipsToBounds = true
        coverPhotoButton.layer.cornerRadius = 10
        coverPhotoButton.loadImage(group.coverPhoto, placeHolder: UIImage.asset(.album))
        coverPhotoButton.imageView?.contentMode = .scaleAspectFill
    }
    
    private func showPhotoAlert() {
        
        coverPhotoButton.showButtonFeedbackAnimation {}
    }
}
