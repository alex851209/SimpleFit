//
//  GroupDetailVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/17.
//

import UIKit

class GroupDetailVC: UIViewController {

    private struct Segue {
        
        static let addChallenge = "SegueAddChallenge"
        static let sendInvitation = "SegueSendInvitation"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    let provider = GroupProvider()
    var group = Group(id: "", coverPhoto: "", name: "", content: "", category: "")
    var members = [User]()
    var challenges = [Challenge]()
    var user = User()
    var photosURL = [URL]()
    var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureTableView()
        fetchMember()
        fetchChallenge()
        fetchAlbum()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchMember() {
        
        provider.fetchMembers(in: group) { [weak self] result in
            
            switch result {
            
            case .success(let members):
                self?.members = members
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
                self?.tableView.reloadData()
                
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
        
        if challenges.isEmpty {
            
            let emptyLabel = UILabel()
            let separator = UIView()
            
            emptyLabel.text = "目前尚無挑戰"
            emptyLabel.font = UIFont.systemFont(ofSize: 16)
            emptyLabel.textColor = .systemGray2
            emptyLabel.frame = CGRect(x: 16, y: 40, width: 100, height: 35)
            
            separator.backgroundColor = UIColor.black.withAlphaComponent(0.05)
            separator.frame = CGRect(x: 16, y: 70, width: UIScreen.main.bounds.width - 32, height: 1)
            
            view.addSubview(emptyLabel)
            view.addSubview(separator)
        }
        
        return view
    }
    
    private func configurePhotoCellHeight() -> CGFloat {
        
        return albums.isEmpty ? 70 : 250
    }
    
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
        
        provider.uploadPhotoWith(image: image) { [weak self] result in
            
            switch result {
            
            case .success(let url):
                self?.addPhoto(with: url)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addPhoto(with url: URL) {
        
        provider.addPhoto(in: group, from: user, with: url) { [weak self] result in
            
            switch result {
            
            case .success(let url):
                print("Success adding new photo with URL: \(url)")
                self?.fetchAlbum()
                
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
            sendInvitationVC.callback = { [weak self] in
                
                self?.fetchMember()
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
        
        return section == 2 ? configureHeaderView() : UIView()
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
            memberCell.callback = { [weak self] in
                
                self?.performSegue(withIdentifier: Segue.sendInvitation, sender: nil)
            }
            
            return memberCell
            
        case 2:
            reuseID = String(describing: ChallengeCell.self)
            guard let challengeCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                                    for: indexPath) as? ChallengeCell
            else { return cell }
            
            challengeCell.layoutCell(with: challenges[indexPath.row])
            
            return challengeCell
            
        case 3:
            reuseID = String(describing: PhotoCell.self)
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                                for: indexPath) as? PhotoCell
            else { return cell }
            
            photoCell.layoutCell(with: albums)
            photoCell.callback = { [weak self] in
                
                self?.showPhotoAlert()
            }
            
            return photoCell
            
        default: return cell
        }
    }
}

extension GroupDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let selectedPhoto = info[.editedImage] as? UIImage else { return }
        
        uploadPhoto(with: selectedPhoto)
        
        dismiss(animated: true)
    }
}
