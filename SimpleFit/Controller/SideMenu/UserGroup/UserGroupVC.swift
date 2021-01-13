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
        static let groupInvitation = "SegueGroupInvitation"
        static let newInvitation = "SegueNewInvitation"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel! {
        
        didSet { titleLabel.applyBorder() }
    }
    @IBOutlet weak var addButton: UIButton! {
        
        didSet { addButton.applyAddButton() }
    }
    @IBOutlet weak var inviteListButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    @IBAction func addButtonDidTap(_ sender: Any) { showAddGroupPage() }
    @IBAction func inviteListButtonDidTap(_ sender: Any) { showInvitePage() }
    
    let userProvider = UserProvider()
    let provider = GroupProvider()
    var groupList = [Group]()
    var memberCounts = [String: Int]()
    var owner = Owner()
    var selectedGroup: Group?
    var user = User()
    var invitationList = [Invitation]()
    var members = [User]()
    var challenges = [Challenge]()
    var albums = [Album]()
    var hasNewInvitation = true
    let emptyView = SFEmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureOwner()
        configureTableView()
        listenInvitations()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        configureEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchGroup()
    }
    
    private func configureEmptyView() {
        
        emptyView.frame = CGRect(x: 0,
                                 y: tableView.frame.minY,
                                 width: tableView.frame.width,
                                 height: tableView.frame.height)
        
        emptyView.arrowAnimationView.isHidden = true
        emptyView.emptyTitleLabel.text = "快去新增群組吧！"
        
        if groupList.isEmpty {
            view.insertSubview(emptyView, aboveSubview: tableView)
        } else {
            emptyView.removeFromSuperview()
        }
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureOwner() {
        
        guard let avatar = user.avatar,
              let name = user.name
        else { return }
        
        owner.avatar = avatar
        owner.name = name
    }
    
    private func configureNewInvitation() {
        
        if hasNewInvitation {
            hasNewInvitation = false
            self.performSegue(withIdentifier: Segue.newInvitation, sender: nil)
        }
    }
    
    private func showInvitePage() {
        
        inviteListButton.showButtonFeedbackAnimation { [weak self] in
            self?.performSegue(withIdentifier: Segue.groupInvitation, sender: nil)
        }
    }
    
    private func showAddGroupPage() {
        
        addButton.showButtonFeedbackAnimation { [weak self] in
            self?.performSegue(withIdentifier: Segue.addGroup, sender: nil)
        }
    }
    
    private func fetchGroup() {
        
        provider.fetchGroups(of: user) { [weak self] result in
            switch result {
            case .success(let groupList):
                self?.groupList = groupList
                self?.fetchMemberCount()
                self?.configureEmptyView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchMemberCount() {
        
        memberCounts.removeAll()
        
        if groupList.isEmpty { tableView.reloadData() }
        
        for group in groupList {
            provider.fetch(object: .members, in: group) { [weak self] result in
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
    
    private func listenInvitations() {
        
        provider.listenInvitations { [weak self] result in
            switch result {
            case .success(let invitationList):
                if self?.invitationList != invitationList && !invitationList.isEmpty {
                    self?.hasNewInvitation = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.configureNewInvitation()
                    }
                }
                self?.invitationList = invitationList
            case .failure(let error): print(error)
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

                self?.fetchGroup()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchMember() {
        
        guard let selectedGroup = self.selectedGroup else { return }
        
        provider.fetch(object: .members, in: selectedGroup) { [weak self] result in
            switch result {
            case .success(let members):
                guard let members = members as? [User] else { return }
                self?.members = members
                self?.fetchChallenge()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchChallenge() {
        
        guard let selectedGroup = self.selectedGroup else { return }
        
        provider.fetch(object: .challenges, in: selectedGroup) { [weak self] result in
            switch result {
            case .success(let challenges):
                guard let challenges = challenges as? [Challenge] else { return }
                self?.challenges = challenges
                self?.fetchAlbum()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchAlbum() {
        
        guard let selectedGroup = self.selectedGroup else { return }
        
        provider.fetch(object: .album, in: selectedGroup) { [weak self] result in
            switch result {
            case .success(let albums):
                guard let albums = albums as? [Album] else { return }
                self?.albums = albums
                SFProgressHUD.dismiss()
                self?.performSegue(withIdentifier: Segue.groupDetail, sender: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func acceptInvitation(_ id: String) {
        
        provider.acceptInvitation(of: user, invitationID: id) { [weak self] result in
            switch result {
            case .success(let invitationID):
                self?.fetchUserInfo()
                print("Group: \(invitationID) successfully removed from group invitations!")
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
            addGroupVC.callback = { self.fetchUserInfo() }
        case Segue.groupDetail:
            guard let groupDetailVC = segue.destination as? GroupDetailVC,
                  let selectedGroup = self.selectedGroup
            else { return }
            
            groupDetailVC.group = selectedGroup
            groupDetailVC.user = user
            groupDetailVC.members = members
            groupDetailVC.challenges = challenges
            groupDetailVC.albums = albums
            groupDetailVC.callback = { [weak self] user in
                self?.user = user
            }
        case Segue.groupInvitation:
            guard let invitationVC = segue.destination as? InvitationVC else { return }
            
            invitationVC.invitationList = invitationList
            invitationVC.callback = { [weak self] id in
                self?.acceptInvitation(id)
            }
        case Segue.newInvitation:
            guard let newInvitationVC = segue.destination as? NewInvitationVC else { return }
            
            newInvitationVC.invitationsCount = invitationList.count
        default: break
        }
    }
}

extension UserGroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return groupList.count }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 180 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: GroupCell.self)
        
        guard let groupCell = tableView.dequeueReusableCell(
                withIdentifier: reuseID,
                for: indexPath
        ) as? GroupCell else { return cell }
        
        let group = groupList[indexPath.row]
        
        if let memberCount = memberCounts[group.id] {
            groupCell.layoutCell(with: group, memberCount: memberCount)
        }

        return groupCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedGroup = groupList[indexPath.row]
        
        fetchMember()
        selectedCell?.showButtonFeedbackAnimation { SFProgressHUD.showLoading() }
    }
}
