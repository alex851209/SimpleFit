//
//  SideMenuVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import UIKit
import SideMenu

class SideMenuVC: UIViewController {

    private struct Segue {
        
        static let userInfo = "SegueUserInfo"
        static let userFavorite = "SegueUserFavorite"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    let items = SideMenuItemManager.sideMenuItems
    let segues = [Segue.userInfo, nil, Segue.userFavorite, nil, nil]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return items.count }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        guard let sideMenuCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SideMenuCell.self),
                for: indexPath )
                as? SideMenuCell,
              let sideMenu = navigationController as? SideMenuNavigationController
        else { return cell }
        
        sideMenuCell.blurEffectStyle = sideMenu.blurEffectStyle
        sideMenuCell.layoutCell(with: items[indexPath.row])
        return sideMenuCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let identifier = segues[indexPath.row] else { return }
        performSegue(withIdentifier: identifier, sender: nil)
    }
}
