//
//  AddNoteVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit
import MIBlurPopup

class AddNoteVC: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) { dismiss(animated: true) }
    
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatePicker()
        configureNoteTextView()
    }
    
    private func configureDatePicker() {

        datePicker.layer.borderWidth = 1
        datePicker.layer.borderColor = UIColor.systemGray2.cgColor
        datePicker.layer.cornerRadius = datePicker.frame.height / 2
        datePicker.clipsToBounds = true
    }
    
    private func configureNoteTextView() {
        
        noteTextView.transform = CGAffineTransform(rotationAngle: .pi * 0.05)
    }
}

extension AddNoteVC: MIBlurPopupDelegate {
    
    var popupView: UIView { view }
    var blurEffectStyle: UIBlurEffect.Style? { .systemUltraThinMaterial }
    var initialScaleAmmount: CGFloat { 0.1 }
    var animationDuration: TimeInterval { 0.7 }
}
