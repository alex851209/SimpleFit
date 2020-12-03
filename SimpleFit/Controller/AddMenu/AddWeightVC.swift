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
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) { dismiss(animated: true) }
    
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        configureLayout()
    }
    
    private func configureLayout() {
        
        datePicker.applyBorder()
        
        weightText.layer.cornerRadius = 15
        weightText.clipsToBounds = true
        
        addWeightView.layer.borderWidth = 5
        addWeightView.layer.borderColor = UIColor.systemGray5.cgColor
        addWeightView.layer.cornerRadius = 40
        addWeightView.clipsToBounds = true
    }
}

extension AddWeightVC: MIBlurPopupDelegate {
    
    var popupView: UIView { view }
    var blurEffectStyle: UIBlurEffect.Style? { .systemUltraThinMaterial }
    var initialScaleAmmount: CGFloat { 0.1 }
    var animationDuration: TimeInterval { 0.7 }
}
