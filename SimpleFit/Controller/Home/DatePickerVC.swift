//
//  PickDateVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/29.
//

import UIKit
import MIBlurPopup
import ADDatePicker

class DatePickerVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: ADDatePicker! {
        didSet {
            datePicker.clipsToBounds = true
            datePicker.layer.cornerRadius = 40
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        callback?()
        dismiss(animated: true)
    }
    
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatePicker()
        configureTitleLabel()
    }
    
    private func configureDatePicker() {
        
        datePicker.intialDate = Date()
        datePicker.bgColor = .clear
        datePicker.deselectTextColor = UIColor.black.withAlphaComponent(0.2)
        datePicker.selectedBgColor = UIColor.black.withAlphaComponent(0.1)
        datePicker.selectedTextColor = UIColor.black.withAlphaComponent(0.5)
        datePicker.selectionType = .circle
        
        datePicker.delegate = self
    }
    
    private func configureTitleLabel() {
        
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        titleLabel.layer.cornerRadius = 15
        titleLabel.clipsToBounds = true
    }
}

extension DatePickerVC: MIBlurPopupDelegate {
    
    var popupView: UIView { datePicker }
    
    var blurEffectStyle: UIBlurEffect.Style? { .none }
    
    var initialScaleAmmount: CGFloat { 0.1 }
    
    var animationDuration: TimeInterval { 0.7 }
}

extension DatePickerVC: ADDatePickerDelegate {
    
    func ADDatePicker(didChange date: Date) {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM, yyyy"
        titleLabel.text = dateformatter.string(from: date)
    }
}
