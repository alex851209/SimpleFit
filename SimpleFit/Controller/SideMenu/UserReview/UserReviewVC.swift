//
//  UserReviewVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/9.
//

import UIKit

class UserReviewVC: UIViewController {
    
    private struct Segue {
        
        static let pickPeriod = "SeguePickPeriod"
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var subtitles: [UILabel]!
    @IBOutlet weak var periodButton: UIButton!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    
    var beginDate = Date()
    var endDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configurePeriodButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Segue.pickPeriod {
            
            guard let pickPeriodVC = segue.destination as? PickPeriodVC else { return }
            
            pickPeriodVC.beginDate = beginDate
            pickPeriodVC.endDate = endDate
            
            pickPeriodVC.selectedDateCallback = { [weak self] (beginDate, endDate) in
                
                self?.beginDate = beginDate
                self?.endDate = endDate
                
                let beginDateString = DateProvider.dateToDateString(beginDate)
                let endDateString = DateProvider.dateToDateString(endDate)
                
                let periodButtonTitle = "\(beginDateString) ~ \(endDateString)"
                self?.periodButton.setTitle(periodButtonTitle, for: .normal)
            }
        }
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
        subtitles.forEach { $0.applyBorder() }
    }
    
    private func configurePeriodButton() {
        
        let beginDateString = DateProvider.dateToDateString(beginDate)
        let endDateString = DateProvider.dateToDateString(endDate)
        
        let periodButtonTitle = "\(beginDateString) ~ \(endDateString)"
        periodButton.setTitle(periodButtonTitle, for: .normal)
    }
}
