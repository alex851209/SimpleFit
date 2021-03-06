//
//  RemoveMemberAlertVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/23.
//

import UIKit

class RemoveMemberAlertVC: UIAlertController {
    
    var showAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAlert()
    }
    
    init(showAction: @escaping () -> Void) {
        super.init(nibName: nil, bundle: nil)
        
        self.showAction = showAction
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAlert() {
        
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ]
        let titleString = NSAttributedString(string: "移除此成員？", attributes: titleAttributes)
        setValue(titleString, forKey: "attributedTitle")
        
        let confirmAction = UIAlertAction(title: "確定", style: .default) { _ in
            
            self.showAction?()
        }
        let confirmColor = UIColor(red: 156/255, green: 39/255, blue: 6/255, alpha: 1.0)
        confirmAction.setValue(confirmColor, forKey: "titleTextColor")
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel)
        cancleAction.setValue(UIColor.darkGray, forKey: "titleTextColor")
        
        addAction(confirmAction)
        addAction(cancleAction)
    }
}
