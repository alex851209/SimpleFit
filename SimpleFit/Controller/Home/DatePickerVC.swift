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
    @IBOutlet weak var datePicker: ADDatePicker!
    
    @IBAction func dismiss(_ sender: Any) {
        
        callback?(0, 0, true)
        dismiss(animated: true)
    }
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        
        callback?(selectedYear, selectedMonth, false)
        dismiss(animated: true)
    }
    
    var callback: ((Int, Int, Bool) -> Void)?
    var selectedYear = 0
    var selectedMonth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        
        let selectedDate = "\(selectedYear)-\(selectedMonth)-01"
        datePicker.intialDate = DateProvider.dateStringToDate(selectedDate)
        datePicker.bgColor = .clear
        datePicker.deselectTextColor = UIColor.black.withAlphaComponent(0.2)
        datePicker.selectedBgColor = UIColor.black.withAlphaComponent(0.1)
        datePicker.selectedTextColor = UIColor.black.withAlphaComponent(0.5)
        datePicker.selectionType = .circle
        
        datePicker.delegate = self
    }
}

extension DatePickerVC: MIBlurPopupDelegate {
    
    var popupView: UIView { view }
    var blurEffectStyle: UIBlurEffect.Style? { .light }
    var initialScaleAmmount: CGFloat { 0.1 }
    var animationDuration: TimeInterval { 0.7 }
}

extension DatePickerVC: ADDatePickerDelegate {
    
    func ADDatePicker(didChange date: Date) {
        
        selectedYear = date.year()
        selectedMonth = date.month()
        titleLabel.text = "\(selectedYear)年\(selectedMonth)月"
    }
}
