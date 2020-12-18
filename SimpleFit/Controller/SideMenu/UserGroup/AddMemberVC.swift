//
//  AddMemberVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/18.
//

import UIKit

class AddMemberVC: BlurViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addMemberTextField: UITextField!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) { addMember() }
    
    let provider = GroupProvider()
    var user = User()
    var newMember = User()
    var group = Group(id: "", coverPhoto: "", title: "", content: "", category: "")
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        addMemberTextField.delegate = self
        addMemberTextField.layer.cornerRadius = 5
        addMemberTextField.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    private func addMember() {
        
        provider.addMember(newMember, in: group) { [weak self] result in
            
            switch result {
            
            case .success(let newMember):
                print("Success adding new member: \(newMember)")
                self?.callback?()
                self?.dismiss(animated: true)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AddMemberVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1
        
        guard let name = textField.text else { return }
        self.newMember.name = name
    }
}
