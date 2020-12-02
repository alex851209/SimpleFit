//
//  AddWeightVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/2.
//

import UIKit
import MIBlurPopup

class AddWeightVC: UIViewController {

    @IBOutlet weak var addWeightView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var weightText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dismiss(_ sender: Any) {
        
        callback?()
        dismiss(animated: true)
    }
    
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        configureLayout()
    }
    
    private func configureLayout() {
        
        configureAddWeightView()
        configureWeightText()
        configureDatePicker()
    }
    
    private func configureAddWeightView() {
        
        addWeightView.layer.borderWidth = 5
        addWeightView.layer.borderColor = UIColor.systemGray5.cgColor
        addWeightView.clipsToBounds = true
        addWeightView.layer.cornerRadius = 40
    }
    
    private func configureDatePicker() {

        datePicker.layer.borderWidth = 1
        datePicker.layer.borderColor = UIColor.systemGray5.cgColor
        datePicker.layer.cornerRadius = 15
        datePicker.clipsToBounds = true
    }
    
    private func configureWeightText() {
        
        weightText.layer.cornerRadius = 20
        weightText.clipsToBounds = true
    }
}

extension AddWeightVC: MIBlurPopupDelegate {
    
    var popupView: UIView { view }
    var blurEffectStyle: UIBlurEffect.Style? { .systemUltraThinMaterial }
    var initialScaleAmmount: CGFloat { 0.1 }
    var animationDuration: TimeInterval { 0.7 }
}
