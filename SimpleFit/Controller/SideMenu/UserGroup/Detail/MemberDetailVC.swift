//
//  MemberDetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/20.
//

import UIKit

class MemberDetailVC: BlurViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    var member = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        avatarImage.loadImage(member.avatar)
        nameLabel.text = member.name
        genderLabel.text = member.gender
    }
}
