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
}

extension GroupDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 4 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == 0 ? 130 : 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var reuseID = ""
        
        switch indexPath.row {
        
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
