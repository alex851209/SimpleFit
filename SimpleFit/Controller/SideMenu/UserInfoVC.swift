//
//  UserInfoVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit
import MIBlurPopup
import FirebaseAuth

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func editButtonDidTap(_ sender: Any) {
        
        editButton.showButtonFeedbackAnimation { [weak self] in
            
            self?.showAvatarAlert()
        }
    }
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    @IBAction func signOutButtonDidTap(_ sender: Any) {
        
        signOutButton.showButtonFeedbackAnimation { [weak self] in
            
            self?.showSignOutAlert()
        }
    }
    
    let firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        signOutButton.applyBorder()
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
    
    private func showSignOutAlert() {
        
        let alert = SignOutAlertVC(showAction: signOut)
        present(alert, animated: true)
    }
    
    private func signOut() {
        
        do {
            try firebaseAuth.signOut()
            print("Sign out success")
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let mainVC = storyboard.instantiateViewController(identifier: "AuthVC")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                .changeRootViewController(mainVC)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension UserInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
