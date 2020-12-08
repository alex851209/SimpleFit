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
    
    private func feedbackEndingAnimation(_ completion: @escaping () -> Void) {
        
        UIViewPropertyAnimator
            .runningPropertyAnimator(withDuration: 0.1,
                                     delay: 0,
                                     options: .curveLinear,
                                     animations: { [weak self] in
                                        self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                                     },
                                     completion: { [weak self] _ in
                                        self?.isUserInteractionEnabled = true
                                        completion()
                                     })
    }
    
    func showButtonFeedbackAnimation(_ completion: @escaping () -> Void) {
        
        UIViewPropertyAnimator
            .runningPropertyAnimator(withDuration: 0.1,
                                     delay: 0,
                                     options: .curveLinear,
                                     animations: { [weak self] in
                                        self?.transform = CGAffineTransform.init(scaleX: 0.85, y: 0.85)
                                        },
                                     completion: { _ in
                                        self.feedbackEndingAnimation(completion)
                                     })
    }
}
