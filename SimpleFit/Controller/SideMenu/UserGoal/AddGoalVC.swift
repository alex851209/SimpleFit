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
    @IBOutlet weak var goalTitleTextField: UITextField!
    @IBOutlet weak var goalWeightTextField: UITextField!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        
        addGoal()
        callback?()
        dismiss(animated: true)
    }
    
    var callback: (() -> Void)?
    let provider = GoalProvider()
    let beginDate = Date()
    let endDate = DateProvider.getNextMonth()
    var goal = Goal()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        fetchLatestWeight()
    }
    
    private func configure() {
        
        let beginDateString = DateProvider.dateToDateString(beginDate)
        let endDateString = DateProvider.dateToDateString(endDate)
        let title = "# \(beginDateString) ~ \(endDateString)"
        
        titleLabel.applyBorder()
        
        goalTitleTextField.delegate = self
        goalWeightTextField.delegate = self
        goalTitleTextField.placeholder = title
        
        datePicker.minimumDate = Date()
        datePicker.date = DateProvider.getNextMonth()
        datePicker.applyBorder()
        datePicker.layer.cornerRadius = 15
        datePicker.addTarget(self, action: #selector(dateDidPick), for: .valueChanged)
        
        goal.title = title
        goal.beginDate = beginDateString
        goal.endDate = endDateString
    }
    
    private func addGoal() {
        
        provider.addDataWith(goal: goal) { result in
            
            switch result {
            
            case .success(let goal):
                print("Success adding new goal: \(goal)")
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchLatestWeight() {
        
        provider.fetchLatestWeight { [weak self] result in
            
            switch result {
            
            case .success(let weight):
                self?.goal.beginWeight = weight
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func dateDidPick(sender: UIDatePicker) {
        
        let beginDateString = DateProvider.dateToDateString(beginDate)
        let endDateString = DateProvider.dateToDateString(sender.date)
        let title = "# \(beginDateString) ~ \(endDateString)"
        
        goalTitleTextField.placeholder = title
        goal.endDate = endDateString
    }
}

extension AddGoalVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        
        case goalTitleTextField:
            guard let title = goalTitleTextField.text else { return }
            goal.title = "# \(title)"
            
        case goalWeightTextField:
            guard let endWeightString = goalWeightTextField.text,
                  let endWeight = Double(endWeightString)
            else { return }
            goal.endWeight = endWeight
            
        default: break
        }
    }
}
