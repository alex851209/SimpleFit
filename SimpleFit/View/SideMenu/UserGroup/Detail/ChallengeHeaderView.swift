//
//  ChallengeHeaderView.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/24.
//

import UIKit

class ChallengeHeaderView: UIView {

    var selector: Selector?
    var challenges: [Challenge]?
    
    init(selector: Selector, challenges: [Challenge]) {
        super.init(frame: .zero)
        
        self.selector = selector
        self.challenges = challenges
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func configureHeaderView() {
        
        guard let selector = selector,
              let challenges = challenges
        else { return }
        
        let titleLabel = UILabel()
        let addButton = UIButton()
        
        titleLabel.text = "挑戰"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .systemGray
        titleLabel.frame = CGRect(x: 16, y: 2, width: 50, height: 35)
        
        addButton.setImage(UIImage.asset(.add), for: .normal)
        addButton.tintColor = .systemGray3
        addButton.frame = CGRect(x: UIScreen.main.bounds.maxX - 38, y: 8, width: 22, height: 22)
        addButton.addTarget(nil, action: selector, for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(addButton)
        
        if challenges.isEmpty {
            
            let emptyLabel = UILabel()
            let separator = UIView()
            
            emptyLabel.text = "目前尚無挑戰"
            emptyLabel.font = UIFont.systemFont(ofSize: 16)
            emptyLabel.textColor = .systemGray2
            emptyLabel.frame = CGRect(x: 16, y: 40, width: 100, height: 35)
            
            separator.backgroundColor = UIColor.black.withAlphaComponent(0.05)
            separator.frame = CGRect(x: 16, y: 70, width: UIScreen.main.bounds.width - 32, height: 1)
            
            addSubview(emptyLabel)
            addSubview(separator)
        }
    }
}
