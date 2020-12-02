//
//  DetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/1.
//

import UIKit
import MIBlurPopup

class DetailVC: UIViewController {
    
    @IBOutlet weak var detailView: UIView! {
        didSet {
            detailView.clipsToBounds = true
            detailView.layer.cornerRadius = 40
        }
    }
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
        
        weightLabel.layer.cornerRadius = weightLabel.frame.width / 2
        weightLabel.clipsToBounds = true
        
        photoImage.image = UIImage.asset(.album)
        
        noteTextView.layer.cornerRadius = 20
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.systemGray.cgColor
        noteTextView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }
}

extension DetailVC: MIBlurPopupDelegate {
    
    var popupView: UIView { detailView }
    var blurEffectStyle: UIBlurEffect.Style? { .systemUltraThinMaterialDark }
    var initialScaleAmmount: CGFloat { 0.1 }
    var animationDuration: TimeInterval { 0.7 }
}
