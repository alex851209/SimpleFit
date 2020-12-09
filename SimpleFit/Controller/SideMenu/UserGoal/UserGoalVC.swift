//
//  UserGoalVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/8.
//

import UIKit

class UserGoalVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureTableView()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
    }
}

extension UserGoalVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 5 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 220 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: GoalCell.self)
        
        guard let goalCell = tableView.dequeueReusableCell(
                withIdentifier: reuseID,
                for: indexPath) as? GoalCell
        else { return cell }
        
        goalCell.layoutCell()
        
        return goalCell
    }
}
