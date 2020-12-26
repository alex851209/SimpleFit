//
//  InvitationVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/18.
//

import UIKit

class InvitationVC: BlurViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel! {
        
        didSet { titleLabel.applyBorder() }
    }
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    override var blurEffectStyle: UIBlurEffect.Style? { return .prominent }
    
    var invitationList = [Invitation]()
    var callback: ((String) -> Void)?
    let emptyView = SFEmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureEmptyView()
        configureTableView()
    }
    
    private func configureEmptyView() {
        
        emptyView.frame = CGRect(x: 0,
                                 y: tableView.frame.minY,
                                 width: tableView.frame.width,
                                 height: tableView.frame.height)
        
        emptyView.arrowAnimationView.isHidden = true
        emptyView.emptyTitleLabel.text = "目前沒有群組邀請！"
        
        if invitationList.isEmpty {
            view.addSubview(emptyView)
        } else {
            emptyView.removeFromSuperview()
        }
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
    }
    
    private func removeInvitation(id: String) {
        
        if let index = invitationList.firstIndex(where: { $0.id == id }) {
            
            invitationList.remove(at: index)
            configureEmptyView()
        }
        tableView.reloadData()
    }
}

extension InvitationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return invitationList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: InvitationCell.self)
        
        guard let invitationCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                                 for: indexPath) as? InvitationCell
        else { return cell }
        
        invitationCell.layoutCell(with: invitationList[indexPath.row])
        invitationCell.callback = { [weak self] id in
            
            SFProgressHUD.showSuccess()
            self?.callback?(id)
            self?.removeInvitation(id: id)
        }
        
        return invitationCell
    }
}
