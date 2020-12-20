//
//  UserInfoVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit
import FirebaseAuth

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarEditButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBAction func editButtonDidTap(_ sender: Any) {
        
        editButton.showButtonFeedbackAnimation { [weak self] in
            
            self?.switchMode()
        }
    }
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
    let provider = UserProvider()
    var isEdit = false
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        fetchInfo()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        signOutButton.applyBorder()
        
        nameTextField.delegate = self
        heightTextField.delegate = self
        
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        
        genderSegmentedControl.addTarget(self, action: #selector(genderDidSelect), for: .valueChanged)
        let normalAttribute = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        let selectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(normalAttribute, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(selectedAttribute, for: .selected)
    }
    
    private func configureInfo(with user: User) {
        
        nameTextField.text = user.name
        heightTextField.text = ""
        avatarImage.loadImage(user.avatar)
        
        if let height = user.height { heightTextField.text = String(describing: height) }
        
        if user.gender == "男" || user.gender == nil {
            genderSegmentedControl.selectedSegmentIndex = 0
        } else {
            genderSegmentedControl.selectedSegmentIndex = 1
        }
        
        self.user = user
    }
    
    private func switchMode() {
        
        if isEdit {
            
            editButton.setImage(UIImage.asset(.edit), for: .normal)
            isEdit = false
            uploadAvatar()
        } else {
            
            editButton.setImage(UIImage.asset(.confirm), for: .normal)
            isEdit = true
        }
        
        nameTextField.isEnabled = isEdit
        genderSegmentedControl.isEnabled = isEdit
        heightTextField.isEnabled = isEdit
        avatarEditButton.isHidden = !isEdit
        
        nameTextField.borderStyle = isEdit ? .roundedRect : .none
        heightTextField.borderStyle = isEdit ? .roundedRect : .none
    }
    
    private func uploadInfo() {
        
        provider.uploadInfoWith(user: user) { user in
            
            print(user)
        }
    }
    
    private func fetchInfo() {
        
        provider.fetchInfo { [weak self] result in
            
            switch result {
            
            case .success(let user):
                self?.configureInfo(with: user)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func uploadAvatar() {
        
        guard let avatar = avatarImage.image else { return }
        provider.uploadAvatarWith(image: avatar) { [weak self] result in
            
            switch result {
            
            case .success(let avatarURL):
                print("Success uploading new avatar with url: \(avatarURL)")
                let urlString = "\(avatarURL)"
                self?.user.avatar = urlString
                self?.uploadInfo()
                
            case .failure(let error):
                print(error)
            }
        }
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
            
            let authVC = UIStoryboard.auth.instantiateViewController(identifier: AuthVC.identifier)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?
                .changeRootViewController(authVC)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @objc private func genderDidSelect(sender: UISegmentedControl) {
        
        let gender = sender.titleForSegment(at: sender.selectedSegmentIndex)
        user.gender = gender
    }
}

extension UserInfoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let selectedPhoto = info[.editedImage] as? UIImage else { return }
        avatarImage.image = selectedPhoto
        dismiss(animated: true)
    }
}

extension UserInfoVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        
        case nameTextField:
            guard let isEmptyName = textField.text?.isEmpty else { return }
            user.name = isEmptyName ? nil : textField.text
            
        case heightTextField:
            if let heightString = textField.text, let height = Double(heightString) {
                user.height = height
            } else {
                user.height = nil
            }
            
        default: break
        }
        
        textField.layer.borderWidth = 0
    }
}
