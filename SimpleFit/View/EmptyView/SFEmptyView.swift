//
//  GoalEmptyView.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/26.
//

import UIKit
import Lottie

class SFEmptyView: UIView {
    
    let animationView = AnimationView(name: "330-empty-status")
    let arrowAnimationView = AnimationView(name: "lf30_editor_fzr8opl3")
    let emptyTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        
        arrowAnimationView.transform = CGAffineTransform(scaleX: -1, y: 1).rotated(by: .pi * 0.1)
        arrowAnimationView.loopMode = .repeat(3.0)
        
        emptyTitleLabel.text = "點擊新增目標吧！"
        emptyTitleLabel.textAlignment = .center
        emptyTitleLabel.font = UIFont.systemFont(ofSize: 20)
        emptyTitleLabel.textColor = .systemGray
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        arrowAnimationView.translatesAutoresizingMaskIntoConstraints = false
        emptyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(animationView)
        addSubview(arrowAnimationView)
        addSubview(emptyTitleLabel)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50),
            animationView.widthAnchor.constraint(equalToConstant: 350),
            animationView.heightAnchor.constraint(equalToConstant: 350),
            
            arrowAnimationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            arrowAnimationView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            arrowAnimationView.widthAnchor.constraint(equalToConstant: 100),
            arrowAnimationView.heightAnchor.constraint(equalToConstant: 50),
            
            emptyTitleLabel.centerXAnchor.constraint(equalTo: animationView.centerXAnchor),
            emptyTitleLabel.topAnchor.constraint(equalTo: arrowAnimationView.bottomAnchor, constant: 10)
        ])
        
        animationView.play()
        arrowAnimationView.play()
    }
}
