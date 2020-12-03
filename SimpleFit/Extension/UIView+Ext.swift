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
        layer.masksToBounds = true
    }
    
    func applyShadow() {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
}
