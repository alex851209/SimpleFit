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
    
    @IBOutlet weak var titleLabel: UILabel! {
        
        didSet { titleLabel.applyBorder() }
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    let provider = ChartProvider()
    var allFavorites = [DailyData]()
    var monthFavorites = [Favorite]()
    var selectedMonthIndex: Int?
    let emptyView = SFEmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureFavoriteOfmonth()
        configureTableView()
        configureEmptyView()
    }
    
    private func configureEmptyView() {
        
        emptyView.frame = CGRect(x: 0,
                                 y: tableView.frame.minY,
                                 width: tableView.frame.width,
                                 height: tableView.frame.height)
        emptyView.arrowAnimationView.isHidden = true
        emptyView.emptyTitleLabel.text = "快去新增收藏吧！"
        
        if allFavorites.isEmpty { view.addSubview(emptyView) }
    }
    
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
