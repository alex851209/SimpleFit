//
//  GroupDetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/17.
//

import UIKit

class GroupDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    let provider = GroupProvider()
    var group = Group(id: "", coverPhoto: "", title: "", content: "", category: "")
    var members = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureTableView()
        fetchMember()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchMember() {
        
        provider.fetchMember(in: group) { [weak self] result in
            
            switch result {
            
            case .success(let members):
                self?.members = members
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func addChallenge(sender: UIButton) {
        
        sender.showButtonFeedbackAnimation {}
    }
    
    private func configureHeaderView() -> UIView? {
        
        let view = UIView()
        let titleLabel = UILabel()
        let addButton = UIButton()
        
        titleLabel.text = "挑戰"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .systemGray
        titleLabel.frame = CGRect(x: 16, y: 2, width: 50, height: 35)
        
        addButton.setImage(UIImage.asset(.add), for: .normal)
        addButton.tintColor = .systemGray3
        addButton.frame = CGRect(x: UIScreen.main.bounds.maxX - 38, y: 8, width: 22, height: 22)
        addButton.addTarget(self, action: #selector(addChallenge(sender:)), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        
        return view
    }
}

extension GroupDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 2 ? 5 : 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 4 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return section == 2 ? configureHeaderView() : UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 2 ? 40 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 0
        
        switch indexPath.section {
        
        case 0: height = 135
        case 1: height = 90
        case 2: height = 44
        case 3: height = 44
        default: break
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var reuseID = ""
        
        switch indexPath.section {
        
        case 0:
            reuseID = String(describing: InfoCell.self)
            guard let infoCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                               for: indexPath) as? InfoCell
            else { return cell }
            
            infoCell.layoutCell(with: group)
            
            return infoCell
            
        case 1:
            reuseID = String(describing: MemberCell.self)
            guard let memberCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                                 for: indexPath) as? MemberCell
            else { return cell }
            
            memberCell.layoutCell(with: members)
            
            return memberCell
            
        case 2:
            reuseID = String(describing: ChallengeCell.self)
            guard let challengeCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                                    for: indexPath) as? ChallengeCell
            else { return cell }
            
            return challengeCell
            
        case 3:
            reuseID = String(describing: PhotoCell.self)
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                                for: indexPath) as? PhotoCell
            else { return cell }
            
            return photoCell
            
        default: return cell
        }
    }
}
