//
//  AddMemberVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/18.
//

import UIKit

class SendInvitationVC: BlurViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addMemberTextField: UITextField!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) { sendInvitation() }
    
    let provider = GroupProvider()
    var user = User()
    var invitee = User()
    var group = Group(id: "", coverPhoto: "", name: "", content: "", category: "")
    
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
    
    private func sendInvitation() {
        
        provider.sendInvitaion(from: user, to: invitee, in: group) { [weak self] result in
            
            switch result {
            
            case .success(let invitee):
                print("Success sending invitation to: \(invitee)")
                self?.dismiss(animated: true)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SendInvitationVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1
        
        guard let name = textField.text else { return }
        self.invitee.name = name
    }
}
