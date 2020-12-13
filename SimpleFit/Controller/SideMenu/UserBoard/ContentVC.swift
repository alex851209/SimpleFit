//
//  ArticleVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/14.
//

import UIKit

class ContentVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureTableView()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        replyButton.applyAddButton()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ContentVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 { return 500 }
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 1 ? 40 : 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 16,
                                       y: 8,
                                       width: 100,
                                       height: 35)
        titleLabel.text = "回應"
        titleLabel.textColor = .systemGray
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        headerView.addSubview(titleLabel)
        return section == 1 ? headerView : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        switch indexPath.section {
        
        case 0 :
            let reuseID = String(describing: ContentCell.self)
            
            guard let contentCell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
                    as? ContentCell else { return cell }
            contentCell.layoutCell()
            
            return contentCell
            
        case 1:
            let reuseID = String(describing: ReplyCell.self)
            
            guard let replyCell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
                    as? ReplyCell else { return cell }
            replyCell.layoutCell()
            
            return replyCell
            
        default: break
        }
        
        return cell
    }
}
