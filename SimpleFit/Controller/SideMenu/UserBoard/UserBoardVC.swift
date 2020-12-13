//
//  UserBoardVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/13.
//

import UIKit

class UserBoardVC: UIViewController {

    struct Segue {
        
        static let post = "SeguePost"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    @IBAction func sortButtonDidTap(_ sender: Any) {
        
        sortButton.showButtonFeedbackAnimation { [weak self] in
            
            self?.configureSortButton()
        }
    }
    @IBAction func postButtonDidTap(_ sender: Any) {
        
        postButton.showButtonFeedbackAnimation { [weak self] in
            
            self?.performSegue(withIdentifier: Segue.post, sender: nil)
        }
    }
    
    var isSortByTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureTableview()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        postButton.applyAddButton()
    }
    
    private func configureTableview() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureSortButton() {
        
        if isSortByTime {
            sortButton.setImage(UIImage.systemAsset(.heart), for: .normal)
            isSortByTime = false
        } else {
            sortButton.setImage(UIImage.systemAsset(.time), for: .normal)
            isSortByTime = true
        }
    }
}

extension UserBoardVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 10 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 130 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: BoardCell.self)
        
        guard let boardCell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        as? BoardCell else { return cell }
        
        return boardCell
    }
}
