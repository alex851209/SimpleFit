//
//  PostVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/13.
//

import UIKit

class PostVC: BlurViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureCategory()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        categoryTextField.applyBorder()
        titleTextField.applyBorder()
        contentTextView.applyBorder()
        
        categoryTextField.layer.cornerRadius = 5
        categoryTextField.layer.borderColor = UIColor.systemGray4.cgColor
        titleTextField.layer.cornerRadius = 5
        titleTextField.layer.borderColor = UIColor.systemGray4.cgColor
        contentTextView.layer.cornerRadius = 5
        contentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        
        avatarImage.applyBorder()
        avatarImage.layer.borderWidth = 2
    }
    
    private func configureCategory() {
        
        CategoryManger.categoryItems.forEach { categories.append($0.title) }
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        categoryTextField.inputView = picker
    }
}

extension PostVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoryTextField.text = categories[row]
    }
}
