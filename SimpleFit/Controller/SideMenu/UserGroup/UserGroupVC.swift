//
//  UserGroupVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/14.
//

import UIKit

class UserGroupVC: UIViewController {

    private struct Segue {
    
        static let addGroup = "SegueAddGroup"
        static let groupDetail = "SegueGroupDetail"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    @IBAction func addButtonDidTap(_ sender: Any) {
        
        addButton.showButtonFeedbackAnimation { [weak self] in
            
            self?.performSegue(withIdentifier: Segue.addGroup, sender: nil)
        }
    }
    
    let userProvider = UserProvider()
    let provider = GroupProvider()
    var groupList = [Group]()
    var memberCounts = [String: Int]()
    var owner = Owner()
    var selectedGroup: Group?
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        fetchUserInfo()
        fetchGroup()
        configureTableView()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchGroup() {
        
        provider.fetchGroup { [weak self] result in
            
            switch result {
            
            case .success(let groupList):
                self?.groupList = groupList
                self?.fetchMemberCount()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchMemberCount() {
        
        for group in groupList {
            
            provider.fetchMember(in: group) { [weak self] result in
                
                switch result {
                
                case .success(let memberList):
                    self?.memberCounts[group.id] = memberList.count
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func fetchUserInfo() {
        
        userProvider.fetchInfo { [weak self] result in
            
            switch result {
            
            case .success(let user):
                guard let name = user.name,
                      let avatar = user.avatar
                else { return }
                
                self?.user = user
                self?.owner.name = name
                self?.owner.avatar = avatar
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        
        case Segue.addGroup:
            guard let addGroupVC = segue.destination as? AddGroupVC else { return }
            
            addGroupVC.newGroup.owner = owner
            addGroupVC.user = user
            addGroupVC.callback = { self.fetchGroup() }
            
        case Segue.groupDetail:
            guard let groupDetailVC = segue.destination as? GroupDetailVC,
                  let selectedGroup = selectedGroup
            else { return }
            
            groupDetailVC.group = selectedGroup
            groupDetailVC.user = user
            
        default: break
        }
    }
}

extension UserGroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return memberCounts.count }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 180 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: GroupCell.self)
        
        guard let groupCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                            for: indexPath) as? GroupCell
        else { return cell }
        
        let group = groupList[indexPath.row]
        
        if let memberCount = memberCounts[group.id] {
            
            groupCell.layoutCell(with: group, memberCount: memberCount)
        }

        return groupCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedGroup = groupList[indexPath.row]
        
        selectedCell?.showButtonFeedbackAnimation { [weak self] in
            
            self?.performSegue(withIdentifier: Segue.groupDetail, sender: nil)
        }
    }
}
