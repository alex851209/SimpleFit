//
//  UserFavoriteVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit
import Gemini

struct Favorite {
    
    var month: String
    var dailys: [DailyData]
}

class UserFavoriteVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    let provider = ChartProvider()
    var allFavorites = [DailyData]()
    var monthFavorites = [Favorite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureFavoriteDaily()
        configureTableView()
    }
    
    private func configureLayout() { titleLabel.applyBorder() }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureFavoriteOfmonth() {
        
        let months = allFavorites.map({ $0.month }).removingDuplicates()
        
        for month in months {
            
            let dailys = allFavorites.filter { $0.month == month }
            monthFavorites.append(Favorite(month: month, dailys: dailys))
        }
    }
    
    private func configureFavoriteDaily() {
        
        provider.fetchFavoriteDatas { [weak self] result in
            
            switch result {
            
            case .success(let allFavorites):
                self?.allFavorites = allFavorites
                self?.configureFavoriteOfmonth()
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension UserFavoriteVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return monthFavorites.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 150 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: FavoriteMonthCell.self)
        
        guard let favoriteMonthCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                                    for: indexPath) as? FavoriteMonthCell
        else { return cell }
        
        favoriteMonthCell.layoutCell(with: monthFavorites[indexPath.row])
        
        return favoriteMonthCell
    }
}
