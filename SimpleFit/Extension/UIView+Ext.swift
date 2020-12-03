//
//  UIView+Ext.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit

extension UIView {
    
    func applyBorder() {
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
