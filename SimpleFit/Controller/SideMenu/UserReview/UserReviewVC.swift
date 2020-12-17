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
    @IBOutlet weak var periodButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var chartBackgroundView: UIView!
    @IBOutlet weak var beginWeightLabel: UILabel!
    @IBOutlet weak var endWeightLabel: UILabel!
    @IBOutlet weak var minWeightLabel: UILabel!
    @IBOutlet weak var maxWeightLabel: UILabel!
    @IBOutlet weak var weightChangeLabel: UILabel!
    @IBOutlet weak var changeSymbolImge: UIImageView!
    
    @IBAction func backButtonDidTap(_ sender: Any) { navigationController?.popViewController(animated: true) }
    @IBAction func calendarButtonDidTap(_ sender: Any) {
        
        calendarButton.showButtonFeedbackAnimation { [weak self] in
                        
            self?.performSegue(withIdentifier: Segue.pickPeriod, sender: nil)
        }
    }
    
    let chartView = AAChartView()
    var chartModel = AAChartModel()
    var chartOptions = AAOptions()
    let provider = ReviewProvider()
    var beginDate = DateProvider.getLastMonth(Date())
    var endDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configurePeriodButton()
        fetchReview()
    }
    
    private func fetchReview() {
        
        provider.fetchReviewDatas(from: beginDate, to: endDate) { [weak self] result in
            
            switch result {
            
            case .success: self?.configureChart()
            case .failure(let error): print(error)
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
        
        let chartData = provider.getChartData()
        
        configureWeightLabels(with: chartData)
        
        guard let weightsDatas = chartData.datas,
              let categories = chartData.categories
        else { return }
        
        chartModel = AAChartModel()
                        .categories(categories)
                        .chartType(.line) // 圖表類型
                        .colorsTheme(["#c0c0c0"])
                        .legendEnabled(false) // 是否啟用圖表的圖例(圖表底部的可點擊的小圓點)
                        .markerRadius(0) // 連接點大小
                        .series([AASeriesElement().name("體重").data(weightsDatas as [Any])])
                        .tooltipValueSuffix("公斤")//浮動提示框單位後綴
                        .xAxisLabelsEnabled(false)
                        .zoomType(.x) // x軸縮放
        
        let crosshair = AACrosshair().width(2)
        chartOptions = chartModel.aa_toAAOptions()
        chartOptions.plotOptions?.series?.connectNulls(true)
        chartOptions.xAxis?.crosshair(crosshair)
    }
    
    private func configureWeightLabels(with chartData: ChartData) {
        
        guard let beginWeight = chartData.datas?.first,
              let endWeight = chartData.datas?.last
        else { return }
        
        let beginWeightString = "\(beginWeight ?? 0)" + " 公斤"
        let endWeightString = "\(endWeight ?? 0)" + " 公斤"
        let minWeightString = "\(chartData.min ?? 0)" + " 公斤"
        let maxWeightString = "\(chartData.max ?? 0)" + " 公斤"
        
        let weightIsUp = endWeight! > beginWeight!
        
        let weightChangeValue = abs(endWeight! - beginWeight!).round(to: 1)
        let weightChangeRate = (weightChangeValue / beginWeight! * 100).round(to: 1)
        let weightChangeValueString = "\(weightChangeValue)" + " 公斤"
        let symbolString = weightIsUp ? "+" : "-"
        let weightChangeRateString = "(\(symbolString) \(weightChangeRate)%)"
        
        beginWeightLabel.text = beginWeightString
        endWeightLabel.text = endWeightString
        minWeightLabel.text = minWeightString
        maxWeightLabel.text = maxWeightString
        weightChangeLabel.text = weightChangeValueString + weightChangeRateString
        
        let transformY: CGFloat = weightIsUp ? 1 : -1
        let upColor = UIColor(red: 192/255, green: 255/255, blue: 51/255, alpha: 1)
        let downColor = UIColor(red: 251/255, green: 75/255, blue: 75/255, alpha: 1)
        let symbolColor = weightIsUp ? upColor : downColor
        
        changeSymbolImge.transform = CGAffineTransform(scaleX: 1, y: transformY)
        changeSymbolImge.tintColor = symbolColor
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
                self?.fetchReview()
            }
        }
    }
}
