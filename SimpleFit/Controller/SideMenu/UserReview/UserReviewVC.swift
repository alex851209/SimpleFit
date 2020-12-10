//
//  UserReviewVC.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/9.
//

import UIKit
import AAInfographics

class UserReviewVC: UIViewController {
    
    private struct Segue {
        
        static let pickPeriod = "SeguePickPeriod"
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var subtitles: [UILabel]!
    @IBOutlet weak var periodButton: UIButton!
    @IBOutlet weak var chartBackgroundView: UIView!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    @IBAction func calendarButtonDidTap(_ sender: Any) { performSegue(withIdentifier: Segue.pickPeriod, sender: nil) }
    
    let chartView = AAChartView()
    var chartModel = AAChartModel()
    var chartOptions = AAOptions()
    var beginDate = Date()
    var endDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configurePeriodButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        configureChart()
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
    
    private func configureChart() {
        
        configureChartView()
        configureChartModel()
        chartView.aa_drawChartWithChartOptions(chartOptions)
    }
    
    private func configureChartView() {
        
        let chartViewWidth  = chartBackgroundView.frame.size.width
        let chartViewHeight = chartBackgroundView.frame.size.height
        chartView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: chartViewWidth,
                                 height: chartViewHeight)
        chartBackgroundView.addSubview(chartView)
    }
    
    private func configureChartModel() {
        
        let categories = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        let datas = AASeriesElement()
                        .name("體重")
                        .data([67.0, 66.9, 69.5, 64.5, 68.2, 61.5, 65.2, 66.5, 63.3, 68.3, 63.9, 69.6])
        
        chartModel = AAChartModel()
                        .categories(categories)
                        .chartType(.line) // 圖表類型
                        .colorsTheme(["#c0c0c0"])
                        .legendEnabled(false) // 是否啟用圖表的圖例(圖表底部的可點擊的小圓點)
                        .markerRadius(0) // 連接點大小
                        .series([datas])
                        .tooltipValueSuffix("公斤")//浮動提示框單位後綴
                        .zoomType(.x) // x軸縮放
        
        let crosshair = AACrosshair().width(2)
        chartOptions = chartModel.aa_toAAOptions()
        chartOptions.plotOptions?.series?.connectNulls(true)
        chartOptions.xAxis?.crosshair(crosshair)
    }
    
    private func configureLayout() {
        
        titleLabel.applyBorder()
    }
    
    private func configurePeriodButton() {
        
        let beginDateString = DateProvider.dateToDateString(beginDate)
        let endDateString = DateProvider.dateToDateString(endDate)
        
        let periodButtonTitle = "\(beginDateString) ~ \(endDateString)"
        periodButton.setTitle(periodButtonTitle, for: .normal)
    }
}
