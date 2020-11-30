//
//  PickDateVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/29.
//

import UIKit
import MIBlurPopup

class PickMonthVC: UIViewController {

    @IBOutlet weak var pickMonthView: UIView! {
        didSet { pickMonthView.layer.cornerRadius = 20 }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        callback?()
        dismiss(animated: true)
    }
    
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension PickMonthVC: MIBlurPopupDelegate {
    
    var popupView: UIView { pickMonthView }
    
    var blurEffectStyle: UIBlurEffect.Style? { .none }
    
    var initialScaleAmmount: CGFloat { 0.1 }
    
    var animationDuration: TimeInterval { 0.5 }
}
