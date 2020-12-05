//
//  BlurVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/5.
//

import UIKit
import MIBlurPopup

class BlurViewController: UIViewController ,MIBlurPopupDelegate {
    
    var popupView: UIView { view }
    var blurEffectStyle: UIBlurEffect.Style? { .systemUltraThinMaterial }
    var initialScaleAmmount: CGFloat { 0.1 }
    var animationDuration: TimeInterval { 0.7 }
}
