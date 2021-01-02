//
//  GroupDetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/17.
//

import UIKit

enum PhotoType {
    
    case album
    case cover
}

class GroupDetailVC: UIViewController {

    private struct Segue {
        
        static let addChallenge = "SegueAddChallenge"
        static let sendInvitation = "SegueSendInvitation"
        static let memberDetail = "SegueMemberDetail"
        static let albumDetail = "SegueAlbumDetail"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel! {
        
        didSet { titleLabel.applyBorder() }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    @IBAction func exitButtonDidTap(_ sender: UIButton) { showExitAlert(sender) }
    
    let provider = GroupProvider()
    var group = Group(id: "", coverPhoto: "", name: "", content: "", category: "")
    var members = [User]()
    var challenges = [Challenge]()
    var user = User()
    var photosURL = [URL]()
    var albums = [Album]()
    var selectedMember = User()
    var photoType: PhotoType?
    var selectedAlbumIndex = 0
    var callback: ((User) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchGroup() {
        
        provider.fetchGroups(of: user) { [weak self] result in
            
            switch result {
            
            case .success(let groupList):
                let id = self?.group.id
                guard let group = groupList.first( where: { $0.id == id }) else { return }
                self?.group = group
                SFProgressHUD.showSuccess()
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchMember() {
        
        provider.fetchMembers(in: group) { [weak self] result in
            
            switch result {
            
            case .success(let members):
                self?.members = members
                SFProgressHUD.showSuccess()
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchChallenge() {
        
        provider.fetchChallenges(in: group) { [weak self] result in
            
            switch result {
            
            case .success(let challenges):
                self?.challenges = challenges
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchAlbum() {
        
        provider.fetchAlbum(in: group) { [weak self] result in
            
            switch result {
            
            case .success(let albums):
                self?.albums = albums
                SFProgressHUD.showSuccess()
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func showExitAlert(_ sender: UIButton) {
                
        let alert = SFAlertVC(title: "退出群組？", showAction: exitGroup)
        
        sender.showButtonFeedbackAnimation { [weak self] in
            
            self?.present(alert, animated: true)
        }
    }
    
    private func exitGroup() {
        
        SFProgressHUD.showLoading()
        
        guard let groupIndex = user.groups?.firstIndex(of: group.id) else { return }
        
        user.groups?.remove(at: groupIndex)
        
        provider.removeMember(of: user, in: group) { [weak self] result in
            
            switch result {
            
            case .success:
                print("Success exit group: \(String(describing: self?.group))")
                SFProgressHUD.showSuccess()
                self?.navigationController?.popViewController(animated: true)
                guard let user = self?.user else { return }
                self?.callback?(user)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func addChallenge(sender: UIButton) {
        
        sender.showButtonFeedbackAnimation { [weak self] in
            
            self?.performSegue(withIdentifier: Segue.addChallenge, sender: nil)
        }
    }
    
    private func configurePhotoCellHeight() -> CGFloat { return albums.isEmpty ? 70 : 350 }
    
    private func showPhotoAlert() {
        
        let alert = PhotoAlertVC(showAction: showImagePicker(type:))
        present(alert, animated: true, completion: nil)
    }
    
    private func showImagePicker(type: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    private func uploadPhoto(with image: UIImage) {
        
        PhotoManager.shared.uploadPhoto(to: .group, with: image) { [weak self] result in
            
            switch result {
            
            case .success(let url):
                switch self?.photoType {
                
                case .album: self?.addAlbumPhoto(with: url)
                case .cover: self?.addCoverPhoto(with: url)
                default: break
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addCoverPhoto(with url: URL) {
        
        provider.addCoverPhoto(in: group, with: url) { [weak self] result in
            
            switch result {
            
            case .success(let url):
                print("Success adding new cover photo with URL: \(url)")
                self?.fetchGroup()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addAlbumPhoto(with url: URL) {
        
        provider.addAlbumPhoto(in: group, from: user, with: url) { [weak self] result in
            
            switch result {
            
            case .success(let url):
                print("Success adding new photo to album with URL: \(url)")
                self?.fetchAlbum()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func removeChallenge(of id: String) {
        
        SFProgressHUD.showLoading()
        
        provider.removeChallenge(of: id, in: group) { result in
            
            switch result {
            
            case .success:
                print("Success removing challenge: \(id)")
                SFProgressHUD.showSuccess()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        
        case Segue.addChallenge:
            guard let addChallengeVC = segue.destination as? AddChallengeVC else { return }
            
            addChallengeVC.user = user
            addChallengeVC.group = group
            addChallengeVC.callback = { [weak self] in
                
                self?.fetchChallenge()
            }
            
        case Segue.sendInvitation:
            guard let sendInvitationVC = segue.destination as? SendInvitationVC else { return }
            
            sendInvitationVC.user = user
            sendInvitationVC.group = group
            
        case Segue.memberDetail:
            guard let memberDetailVC = segue.destination as? MemberDetailVC else { return }
            
            memberDetailVC.member = selectedMember
            memberDetailVC.group = group
            memberDetailVC.callback = { [weak self] in
                
                self?.fetchMember()
            }
        
        case Segue.albumDetail:
            guard let albumDetailVC = segue.destination as? AlbumDetailVC else { return }
            
            albumDetailVC.album = albums[selectedAlbumIndex]
            albumDetailVC.group = group
            albumDetailVC.callback = { [weak self] in
                
                self?.fetchAlbum()
            }
            
        default: break
        }
    }
}

extension GroupDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 2 ? challenges.count : 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 4 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = ChallengeHeaderView(
            selector: #selector(addChallenge(sender:)),
            challenges: challenges)
        
        return section == 2 ? headerView : UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 2 { return challenges.isEmpty ? 70 : 40 }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 0
        
        switch indexPath.section {
        
        case 0: height = 135
        case 1: height = 90
        case 2: height = 44
        case 3: height = configurePhotoCellHeight()
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
            guard let infoCell = tableView.dequeueReusableCell(
                    withIdentifier: reuseID,
                    for: indexPath
            ) as? InfoCell else { return cell }
            
            infoCell.layoutCell(with: group)
            infoCell.callback = { [weak self] in
                
                self?.photoType = .cover
                self?.showPhotoAlert()
            }
            
            return infoCell
            
        case 1:
            reuseID = String(describing: MemberCell.self)
            guard let memberCell = tableView.dequeueReusableCell(
                    withIdentifier: reuseID,
                    for: indexPath
            ) as? MemberCell else { return cell }
            
            memberCell.layoutCell(with: members)
            memberCell.addMember = { [weak self] in
                
                self?.performSegue(withIdentifier: Segue.sendInvitation, sender: nil)
            }
            memberCell.showMember = { [weak self] member in
                
                self?.selectedMember = member
                self?.performSegue(withIdentifier: Segue.memberDetail, sender: nil)
            }
            
            return memberCell
            
        case 2:
            reuseID = String(describing: ChallengeCell.self)
            guard let challengeCell = tableView.dequeueReusableCell(
                    withIdentifier: reuseID,
                    for: indexPath
            ) as? ChallengeCell else { return cell }
            
            challengeCell.layoutCell(with: challenges[indexPath.row])
            
            return challengeCell
            
        case 3:
            reuseID = String(describing: PhotoCell.self)
            guard let photoCell = tableView.dequeueReusableCell(
                    withIdentifier: reuseID,
                    for: indexPath
            ) as? PhotoCell else { return cell }
            
            photoCell.layoutCell(with: albums)
            photoCell.collectionView.reloadData()
            photoCell.callback = { [weak self] in
                
                self?.photoType = .album
                self?.showPhotoAlert()
            }
            photoCell.showDetail = { [weak self] index in
                
                self?.selectedAlbumIndex = index
                self?.performSegue(withIdentifier: Segue.albumDetail, sender: nil)
            }
            
            return photoCell
            
        default: return cell
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        guard indexPath.section == 2 else { return nil }
        
        let contextItem = UIContextualAction(
            style: .destructive,
            title: "刪除"
        ) { [weak self] (_, _, completion) in
            
            guard let challengeID = self?.challenges[indexPath.row].id else { return }
            self?.challenges.remove(at: indexPath.item)
            self?.tableView.reloadData()
            self?.removeChallenge(of: challengeID)
            completion(true)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

extension GroupDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        
        guard let selectedPhoto = info[.editedImage] as? UIImage else { return }
        
        SFProgressHUD.showLoading()

        uploadPhoto(with: selectedPhoto)
        
        dismiss(animated: true)
    }
}
