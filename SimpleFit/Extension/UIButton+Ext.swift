//
//  UIButton+Ext.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/30.
//

import UIKit

extension UIButton {
    
    func applyAddButton() {
        
        configureMenuButton()
        
        tintColor = .systemGray2
        layer.cornerRadius = 25
        
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -20),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
            widthAnchor.constraint(equalToConstant: 50),
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func applyAddMenuButton() {
        
        configureMenuButton()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 40),
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func applySideMenuButton() {
        
        configureMenuButton()
        
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 8),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16),
            widthAnchor.constraint(equalToConstant: 40),
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func applyPickMonthButtonFor(month: Int) {
        
        setTitle("\(month)月", for: .normal)
        setTitleColor(.systemGray, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 40)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureMenuButton() {
        
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        
        backgroundColor = .white
        tintColor = .systemGray
        
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.3
    }
}
