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
    @IBOutlet weak var titleLabel: UILabel! {
        
        didSet { titleLabel.applyBorder() }
    }
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
    let emptyView = SFEmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureEmptyView()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureEmptyView() {
        
        emptyView.frame = CGRect(x: 0,
                                 y: tableView.frame.minY,
                                 width: tableView.frame.width,
                                 height: tableView.frame.height)
        
        if goalList.isEmpty {
            view.addSubview(emptyView)
        } else {
            emptyView.removeFromSuperview()
        }
    }
    
    private func fetchGoalDatas() {
        
        provider.fetchGoalDatas { [weak self] result in
            
            switch result {
            
            case .success(let goalList):
                self?.goalList = goalList
                self?.tableView.reloadData()
                self?.configureEmptyView()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func removeGoal(with goalID: String) {
        
        SFProgressHUD.showLoading()
        
        provider.removeGoal(with: goalID) { [weak self] result in
            
            switch result {
            
            case .success:
                print("Success removing goal: \(goalID)")
                SFProgressHUD.showSuccess()
                self?.configureEmptyView()
                
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
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(
            style: .destructive,
            title: "刪除"
        ) { [weak self] (_, _, completion) in
            
            guard let goalID = self?.goalList[indexPath.row].id else { return }
            self?.goalList.remove(at: indexPath.item)
            self?.tableView.reloadData()
            self?.removeGoal(with: goalID)
            completion(true)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}
