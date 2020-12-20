//
//  MemberCell.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/17.
//

import UIKit

class MemberCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func addButtonDidTap(_ sender: UIButton) { addMember(sender: sender) }
    
    var addMember: (() -> Void)?
    var showMember: ((User) -> Void)?
    var members = [User]()
    
    func layoutCell(with members: [User]) {
        
        configureMembers(with: members)
    }
    
    private func configureMembers(with members: [User]) {
        
        var padding: CGFloat = 0
        var tag = 0
        
        for member in members {
            
            let avatarButton = UIButton()
            
            if member.avatar == "" {
                avatarButton.setImage(UIImage.asset(.person), for: .normal)
            } else {
                avatarButton.loadImage(member.avatar)
            }
            
            avatarButton.tintColor = .systemGray2
            avatarButton.clipsToBounds = true
            avatarButton.layer.cornerRadius = 20
            
            avatarButton.tag = tag
            avatarButton.addTarget(self, action: #selector(showMember(sender:)), for: .touchUpInside)
            
            avatarButton.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(avatarButton)
            
            NSLayoutConstraint.activate([
                avatarButton.widthAnchor.constraint(equalToConstant: 40),
                avatarButton.heightAnchor.constraint(equalToConstant: 40),
                avatarButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: padding),
                avatarButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
            ])
            
            padding += 50
            tag += 1
        }
        
        self.members = members
    }
    
    @objc private func showMember(sender: UIButton) {
        
        sender.showButtonFeedbackAnimation { [weak self] in
            
            guard let member = self?.members[sender.tag] else { return }
            
            self?.showMember?(member)
        }
    }
    
    private func addMember(sender: UIButton) {
        
        sender.showButtonFeedbackAnimation { [weak self] in
            
            self?.addMember?()
        }
    }
}
