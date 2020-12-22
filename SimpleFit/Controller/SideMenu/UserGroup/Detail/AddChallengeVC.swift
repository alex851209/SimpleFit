//
//  AddChallengeVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/18.
//

import UIKit

class AddChallengeVC: BlurViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var challengeContentTextField: UITextField!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    @IBAction func confirmButtonDidTap(_ sender: Any) { addChallenge() }
    
    var group = Group(id: "", coverPhoto: "", name: "", content: "", category: "")
    var user = User()
    let provider = GroupProvider()
    var challenge = Challenge(id: "", content: "", date: "", createdTime: Date())
    let date = DateProvider.dateToDateString(Date())
    var callback: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        
        challengeContentTextField.delegate = self
        challengeContentTextField.layer.cornerRadius = 5
        challengeContentTextField.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    private func addChallenge() {
        
        guard challengeContentTextField.text != "" else {
            SFProgressHUD.showFailed(with: "請輸入挑戰內容")
            return
        }
        
        SFProgressHUD.showLoading()
        
        provider.addChallenge(in: group, with: challenge) { [weak self] result in
            
            switch result {
            
            case .success(let challenge):
                print("Success adding new challenge: \(challenge)")
                SFProgressHUD.showSuccess()
                self?.callback?()
                self?.dismiss(animated: true)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AddChallengeVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.borderWidth = 1
        
        guard let content = textField.text else { return }
        
        challenge = Challenge(id: "", avatar: user.avatar, content: content, date: date, createdTime: Date())
    }
}
