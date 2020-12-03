//
//  UserFavoriteVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit

class UserFavoriteVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
    }
}
