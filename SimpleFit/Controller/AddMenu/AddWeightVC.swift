//
//  AddWeightVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/2.
//

import UIKit
import MIBlurPopup

class AddWeightVC: UIViewController {

    @IBOutlet weak var addWeightView: UIView! {
        didSet {
            addWeightView.clipsToBounds = true
            addWeightView.layer.cornerRadius = 40
        }
    }
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dismiss(_ sender: Any) {
        
        callback?()
        dismiss(animated: true)
    }
    
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        configureButton()
        configureDatePicker()
    }
    
    private func configureDatePicker() {
        
        datePicker.tintColor = .systemGray
        
        datePicker.layer.borderWidth = 1
        datePicker.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        datePicker.layer.cornerRadius = 15
        datePicker.clipsToBounds = true
    }
    
    private func configureButton() {
        
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        confirmButton.layer.cornerRadius = 15
        confirmButton.clipsToBounds = true
    }
}

extension AddWeightVC: MIBlurPopupDelegate {
    
    var popupView: UIView { addWeightView }
    var blurEffectStyle: UIBlurEffect.Style? { .none }
    var initialScaleAmmount: CGFloat { 0.1 }
    var animationDuration: TimeInterval { 0.7 }
}
