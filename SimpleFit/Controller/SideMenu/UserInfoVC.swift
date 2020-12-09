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
    @IBOutlet weak var avatarEditButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBAction func editButtonDidTap(_ sender: Any) { switchMode() }
    @IBAction func avatarEditButtonDidtap(_ sender: Any) {
        
        avatarEditButton.showButtonFeedbackAnimation { [weak self] in
            
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
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        signOutButton.applyBorder()
        
        nameTextField.delegate = self
        heightTextField.delegate = self
        
        let normalAttribute = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        let selectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(normalAttribute, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(selectedAttribute, for: .selected)
    }
    
    private func switchMode() {
        
        if isEdit {
            
            editButton.setImage(UIImage.asset(.edit), for: .normal)
            isEdit = false
        } else {
            
            editButton.setImage(UIImage.asset(.confirm), for: .normal)
            isEdit = true
        }
        
        nameTextField.isEnabled = isEdit
        genderSegmentedControl.isEnabled = isEdit
        heightTextField.isEnabled = isEdit
        
        nameTextField.borderStyle = isEdit ? .roundedRect : .none
        heightTextField.borderStyle = isEdit ? .roundedRect : .none
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

extension UserInfoVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderWidth = 0
    }
}
