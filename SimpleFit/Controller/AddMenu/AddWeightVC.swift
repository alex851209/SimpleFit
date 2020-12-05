//
//  AddWeightVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/2.
//

import UIKit

class AddWeightVC: BlurViewController {

    @IBOutlet weak var addWeightView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var weightText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        
        addWeight()
        dismiss(animated: true)
    }
    
    var callback: (() -> Void)?
    let provider = ChartProvider()
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        configureLayout()
    }
    
    private func configureLayout() {
        
        datePicker.applyBorder()
        datePicker.addTarget(self, action: #selector(dateDidPick), for: .valueChanged)
        
        weightText.layer.cornerRadius = 15
        weightText.layer.borderWidth = 1
        weightText.layer.borderColor = UIColor.systemGray6.cgColor
        
        addWeightView.layer.borderWidth = 2
        addWeightView.layer.borderColor = UIColor.systemGray6.cgColor
        addWeightView.layer.cornerRadius = 40
        addWeightView.applyShadow()
    }
    
    private func addWeight() {
        
        guard let weightString = weightText.text,
              let weight = Double(weightString)
        else { return }
        
        let daily = DailyData(weight: weight, photo: nil, note: nil)
        provider.addDataWith(dailyData: daily, field: .weight, date: date, completion: { [weak self] result in
            
            switch result {
            
            case .success(let weight):
                let dateString = String(describing: self?.date)
                print("Success adding new weight: \(weight) on date: \(dateString)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    @objc private func dateDidPick(sender: UIDatePicker) { date = sender.date }
}
