//
//  AddGoalVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/9.
//

import UIKit

class AddGoalVC: BlurViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        
        datePicker.minimumDate = Date()
        datePicker.applyBorder()
        datePicker.layer.cornerRadius = 15
    }
}
