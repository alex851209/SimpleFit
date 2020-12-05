//
//  UserInfoVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit
import MIBlurPopup

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func editButtonDidTap(_ sender: Any) { showAvatarAlert() }
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        logoutButton.applyBorder()
    }
    
    private func showAvatarAlert() {
        
        let alert = PhotoAlertVC(showAction: showImagePicker(type:))
        present(alert, animated: true, completion: nil)
    }
    
    private func showImagePicker(type: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension UserInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
