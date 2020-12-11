//
//  PickDateVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/29.
//

import UIKit
import ADDatePicker

class DatePickerVC: BlurViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: ADDatePicker!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        
        callback?(selectedYear, selectedMonth)
        dismiss(animated: true)
    }
    
    var callback: ((Int, Int) -> Void)?
    var selectedYear = 0
    var selectedMonth = 0
    
    override var blurEffectStyle: UIBlurEffect.Style? { .light }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        
        let selectedDate = "\(selectedYear)-\(selectedMonth)-01"
        let currentYear = Date().year()
        
        datePicker.yearRange(inBetween: currentYear - 10, end: currentYear)
        datePicker.intialDate = DateProvider.dateStringToDate(selectedDate)
        datePicker.bgColor = .clear
        datePicker.deselectTextColor = UIColor.black.withAlphaComponent(0.2)
        datePicker.selectedBgColor = UIColor.black.withAlphaComponent(0.1)
        datePicker.selectedTextColor = UIColor.black.withAlphaComponent(0.5)
        datePicker.selectionType = .circle
        
        datePicker.delegate = self
    }
}

extension DatePickerVC: ADDatePickerDelegate {
    
    func ADDatePicker(didChange date: Date) {
        
        selectedYear = date.year()
        selectedMonth = date.month()
        titleLabel.text = "\(selectedYear)年\(selectedMonth)月"
    }
}
