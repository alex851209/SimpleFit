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
    }
}

extension UserGroupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 10 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 150 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: GroupCell.self)
        
        guard let groupCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                            for: indexPath) as? GroupCell
        else { return cell }
        groupCell.layoutCell()
        
        return groupCell
    }
}
