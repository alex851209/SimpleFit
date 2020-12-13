//
//  UserGoalVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/8.
//

import UIKit

class UserGoalVC: UIViewController {
    
    private struct Segue {
        
        static let addGoal = "SegueAddGoal"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    @IBAction func addButtonDidTap(_ sender: Any) {
        
        addButton.showButtonFeedbackAnimation { [weak self] in
            
            self?.performSegue(withIdentifier: Segue.addGoal, sender: nil)
        }
    }
    
    let provider = GoalProvider()
    var goalList = [Goal]()
    var currentWeight: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureTableView()
        fetchLatestWeight()
        fetchGoalDatas()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
    }
    
    private func fetchGoalDatas() {
        
        provider.fetchGoalDatas { [weak self] result in
            
            switch result {
            
            case .success(let goalList):
                self?.goalList = goalList
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchLatestWeight() {
        
        provider.fetchLatestWeight { [weak self] result in
            
            switch result {
            
            case .success(let weight):
                self?.currentWeight = weight
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.addGoal {
            
            guard let addGoalVC = segue.destination as? AddGoalVC else { return }
            addGoalVC.callback = { [weak self] in
                
                self?.fetchGoalDatas()
            }
        }
    }
}

extension UserGoalVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return goalList.count }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 220 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: GoalCell.self)
        
        guard let goalCell = tableView.dequeueReusableCell(
                withIdentifier: reuseID,
                for: indexPath) as? GoalCell
        else { return cell }
        
        goalCell.layoutCell(with: goalList[indexPath.row], currentWeight: currentWeight)
        
        return goalCell
    }
}
