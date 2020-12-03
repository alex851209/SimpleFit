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
    
    @IBAction func editButtonDidTap(_ sender: Any) { editAvatar() }
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        logoutButton.applyBorder()
    }
    
    private func editAvatar() {
        
        let requestController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel)
        let cameraAction = UIAlertAction(title: "相機", style: .default, handler: { [weak self] _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            self?.showImagePicker(type: .camera)
        })
        let albumAction = UIAlertAction(title: "從相簿選取", style: .default, handler: { [weak self] _ in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
            self?.showImagePicker(type: .photoLibrary)
        })
        
        let actions = [cancleAction, cameraAction, albumAction]
        actions.forEach {
            $0.setValue(UIColor.darkGray, forKey: "titleTextColor")
            requestController.addAction($0)
        }
        
        present(requestController, animated: true, completion: nil)
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
