//
//  NewInvitationVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/25.
//

import UIKit
import Lottie

class NewInvitationVC: BlurViewController {

    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    var invitationsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        let animationView = AnimationView(name: "lf30_editor_6cc6svy5")
        let titleLabel = UILabel()
            
        animationView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        animationView.center = CGPoint(x: view.frame.midX, y: view.frame.midY - 100)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        titleLabel.center = CGPoint(x: view.frame.midX, y: animationView.frame.maxY + 70)
        titleLabel.text = "有 \(invitationsCount) 則群組邀請"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.textColor = .systemGray
        
        view.addSubview(animationView)
        view.addSubview(titleLabel)
        
        animationView.play()
    }
}
