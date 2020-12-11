//
//  PickPeriodVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/9.
//

import UIKit

class PickPeriodVC: BlurViewController {
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var beginDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        
        guard endDate > beginDate else {
            
            print("'beginDate' must less than 'endDate'")
            return
        }
        selectedDateCallback?(beginDate, endDate)
        dismiss(animated: true)
    }
    
    var selectedDateCallback: ((Date, Date) -> Void)?
    var beginDate = Date()
    var endDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureDatePicker()
    }
    
    private func configureLayout() {
        
        cardView.cornerRadius = 25
        titleLabel.applyBorder()
    }
    
    private func configureDatePicker() {
        
        beginDatePicker.date = beginDate
        endDatePicker.date = endDate
        beginDatePicker.maximumDate = Date()
        endDatePicker.maximumDate = Date()
        
        beginDatePicker.setValue(UIColor.darkGray, forKeyPath: "textColor")
        endDatePicker.setValue(UIColor.darkGray, forKeyPath: "textColor")
        beginDatePicker.setValue(false, forKey: "highlightsToday")
        endDatePicker.setValue(false, forKey: "highlightsToday")
        beginDatePicker.addTarget(self, action: #selector(beginDateDidPick), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(endDateDidPick), for: .valueChanged)
    }
    
    @objc private func beginDateDidPick(sender: UIDatePicker) { beginDate = sender.date }
    
    @objc private func endDateDidPick(sender: UIDatePicker) { endDate = sender.date }
}
