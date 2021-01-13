//
//  SFProgressView.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/24.
//

import UIKit

class SFProgressView: UIProgressView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientImage = UIImage.gradientImage(
            with: frame,
            colors: [
                UIColor.systemGray4.cgColor,
                UIColor.systemGray.cgColor
            ],
            locations: nil)
        
        progressImage = gradientImage
        
        subviews.forEach { subview in
            subview.clipsToBounds = true
            subview.layer.cornerRadius = frame.height / 2
        }
    }
}
