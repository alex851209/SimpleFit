//
//  UserFavoriteVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/3.
//

import UIKit
import Gemini

struct Favorite {
    
    var month: String = ""
    var dailys: [DailyData] = []
}

class UserFavoriteVC: UIViewController {
    
    private struct Segue {
        
        static let monthFavorite = "SegueMonthFavorite"
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    let provider = ChartProvider()
    var allFavorites = [DailyData]()
    var monthFavorites = [Favorite]()
    var selectedMonthIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureFavoriteOfmonth()
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
        monthFavorites = monthFavorites.reversed()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let monthFavoriteVC = segue.destination as? MonthFavoriteVC,
              let index = selectedMonthIndex
        else { return }
        monthFavoriteVC.favorite = monthFavorites[index]
    }
}

extension UserFavoriteVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return monthFavorites.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 210 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let reuseID = String(describing: UserFavoriteCell.self)
        
        guard let favoriteMonthCell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                                    for: indexPath) as? UserFavoriteCell
        else { return cell }
        
        favoriteMonthCell.layoutCell(with: monthFavorites[indexPath.row])
        
        return favoriteMonthCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedMonthIndex = indexPath.row
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.showButtonFeedbackAnimation { [weak self] in
            
            self?.performSegue(withIdentifier: Segue.monthFavorite, sender: nil)
        }
    }
}
