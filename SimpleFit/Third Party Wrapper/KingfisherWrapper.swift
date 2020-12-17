//
//  KingfisherWrapper.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/7.
//

import UIKit
import Kingfisher

extension UIImageView {

    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {

        guard urlString != nil else { return }
        let url = URL(string: urlString!)
        self.kf.setImage(with: url, placeholder: placeHolder, options: [.transition(.fade(0.4))])
    }
}

extension UIButton {
    
    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {

        guard urlString != nil else { return }
        let url = URL(string: urlString!)
        self.kf.setImage(with: url, for: .normal, placeholder: placeHolder, options: [.transition(.fade(0.4))])
    }
}
