//
//  DetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/1.
//

import UIKit
import MIBlurPopup

class DetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    
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
        
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        titleLabel.layer.cornerRadius = titleLabel.frame.height / 2
        titleLabel.clipsToBounds = true
        
        weightLabel.layer.borderWidth = 1
        weightLabel.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        weightLabel.layer.cornerRadius = weightLabel.frame.width / 2
        weightLabel.clipsToBounds = true
        
        photoImage.image = UIImage.asset(.album)
        
        noteTextView.transform = CGAffineTransform(rotationAngle: .pi * 0.05)
    }
}

extension DetailVC: MIBlurPopupDelegate {
    
    var popupView: UIView { view }
    var blurEffectStyle: UIBlurEffect.Style? { .systemUltraThinMaterial }
    var initialScaleAmmount: CGFloat { 0.1 }
    var animationDuration: TimeInterval { 0.7 }
}
