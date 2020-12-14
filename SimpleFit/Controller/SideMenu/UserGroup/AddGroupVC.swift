//
//  AddGroupVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/14.
//

import UIKit

class AddGroupVC: BlurViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupIntroTextView: UITextView!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        categoryTextField.applyBorder()
        groupNameTextField.applyBorder()
        groupIntroTextView.applyBorder()
        
        categoryTextField.layer.cornerRadius = 5
        categoryTextField.layer.borderColor = UIColor.systemGray4.cgColor
        groupNameTextField.layer.cornerRadius = 5
        groupNameTextField.layer.borderColor = UIColor.systemGray4.cgColor
        groupIntroTextView.layer.cornerRadius = 5
        groupIntroTextView.layer.borderColor = UIColor.systemGray4.cgColor
        
        avatarImage.applyBorder()
        avatarImage.layer.borderWidth = 2
    }
}
