//
//  InvitationVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/18.
//

import UIKit

class InvitationVC: BlurViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func dismiss(_ sender: Any) { dismiss(animated: true) }
    
    override var blurEffectStyle: UIBlurEffect.Style? { return .prominent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureTableView()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
    }
}

extension InvitationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 5 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: InvitationCell.self)
        
        guard let invitationCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                                 for: indexPath) as? InvitationCell
        else { return cell }
        
        invitationCell.layoutCel()
        
        return invitationCell
    }
}
