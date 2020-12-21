//
//  SideMenuVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import UIKit
import SideMenu

class SideMenuVC: UIViewController {

    private struct Segue {
        
        static let userInfo = "SegueUserInfo"
        static let userGroup = "SegueUserGroup"
        static let userFavorite = "SegueUserFavorite"
        static let userReview = "SegueUserReview"
        static let userGoal = "SegueUserGoal"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let items = SideMenuItemManager.sideMenuItems
    let segues = [Segue.userInfo, Segue.userGroup, Segue.userFavorite, Segue.userReview, Segue.userGoal]
    let userProvider = UserProvider()
    let groupProvider = GroupProvider()
    var currentUser = User()
    var groupList = [Group]()
    var memberCounts = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchInfo()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchInfo() {
        
        userProvider.fetchInfo { [weak self] result in
            
            switch result {
            
            case .success(let user):
                self?.currentUser = user
                self?.fetchGroup()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchGroup() {
        
        groupProvider.fetchGroups(of: currentUser) { [weak self] result in
            
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
            
            groupProvider.fetchMembers(in: group) { [weak self] result in
                
                switch result {
                
                case .success(let memberList):
                    self?.memberCounts[group.id] = memberList.count
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        
        case Segue.userInfo:
            guard let userInfoVC = segue.destination as? UserInfoVC else {return }
            userInfoVC.user = currentUser
            
        case Segue.userGroup:
            guard let userGroupVC = segue.destination as? UserGroupVC else { return }
            userGroupVC.user = currentUser
            userGroupVC.groupList = groupList
            userGroupVC.memberCounts = memberCounts
            
        default: break
        }
    }
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return items.count }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 80 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: SideMenuCell.self)
        
        guard let sideMenuCell = tableView.dequeueReusableCell(
                withIdentifier: reuseID,
                for: indexPath) as? SideMenuCell,
              let sideMenu = navigationController as? SideMenuNavigationController
        else { return cell }
        
        sideMenuCell.blurEffectStyle = sideMenu.blurEffectStyle
        sideMenuCell.layoutCell(with: items[indexPath.row])
        return sideMenuCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let reuseID = segues[indexPath.row]
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.showButtonFeedbackAnimation { [weak self] in
            
            self?.performSegue(withIdentifier: reuseID, sender: nil)
        }
    }
}
