//
//  PhotoAlertVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/5.
//

import UIKit

class PhotoAlertVC: UIAlertController {

    var showAction: ((UIImagePickerController.SourceType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAlert()
    }
    
    init(showAction: @escaping (UIImagePickerController.SourceType) -> Void) {
        super.init(nibName: nil, bundle: nil)
        
        self.showAction = showAction
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAlert() {
        
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: "選擇照片", attributes: titleAttributes)
        setValue(titleString, forKey: "attributedTitle")
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel)
        let cameraAction = UIAlertAction(title: "相機", style: .default) { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            self.showAction?(.camera)
        }
        let albumAction = UIAlertAction(title: "從相簿選取", style: .default) { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
            self.showAction?(.photoLibrary)
        }
        
        let actions = [cancleAction, cameraAction, albumAction]
        actions.forEach {
            $0.setValue(UIColor.darkGray, forKey: "titleTextColor")
            addAction($0)
        }
    }
}
