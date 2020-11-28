//
//  ViewController.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/26.
//

import UIKit
import AAInfographics

class HomeVC: UIViewController {
    
    let aaChartView = AAChartView()
    var aaChartModel = AAChartModel()
    let dataProvider = ChartDataProvider()
    var chartData = ChartData()
    var monthLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureChart()
    }
    
    func configureChart() {
        
        configureChartModel()
        configureChartView()
        layoutLabel()
        aaChartView.aa_drawChartWithChartModel(aaChartModel)//圖表視圖對象調用圖表模型對象,繪制最終圖形
    }
    
    private func layoutLabel() {
        
        monthLabel.text = "11月"
        monthLabel.textColor = .systemGray
        monthLabel.font = .systemFont(ofSize: 40)
        
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(monthLabel)
        
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            monthLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    private func configureChartView() {
        
        let chartViewWidth  = view.frame.size.width
        let chartViewHeight = view.frame.size.height - 80
        aaChartView.frame = CGRect(x: 0, y: 0, width: chartViewWidth, height: chartViewHeight)
        view.addSubview(aaChartView)
    }
    
    private func configureChartModel() {
        
        let chartData = dataProvider.getData()
        
        guard let min = chartData.min,
              let max = chartData.max,
              let categories = chartData.categories,
              let weightsData = chartData.datas
        else { return }
        
        aaChartModel = AAChartModel()
                    .touchEventEnabled(true)//是否支持觸摸事件回調
                    .animationDuration(1200)
                    .markerRadius(10)//連接點大小
                    .markerSymbolStyle(.borderBlank)//折線或者曲線的連接點是否為空心的
                    .dataLabelsEnabled(true)//數據標簽是否顯示
                    .dataLabelsFontColor("gray")
                    .dataLabelsFontSize(18)
                    .dataLabelsFontWeight(.bold)
                    .chartType(.spline)//圖表類型
                    .title("Simple Fit")//圖表主標題
//                    .subtitle("2020年11月")//圖表副標題
                    .inverted(false)//是否翻轉圖形
                    .yAxisLabelsEnabled(false)//y 軸是否顯示數據
                    .yAxisMin(min)
                    .yAxisMax(max)
                    .legendEnabled(false)//是否啟用圖表的圖例(圖表底部的可點擊的小圓點)
                    .tooltipValueSuffix("公斤")//浮動提示框單位後綴
                    .tooltipEnabled(true)//是否顯示浮動提示框
                    .tooltipCrosshairs(false)
                    .categories(categories)
                    .colorsTheme(["#c0c0c0"])
                    .scrollablePlotArea(AAScrollablePlotArea().minWidth(2000).scrollPositionX(0))
                    .series([AASeriesElement().name("體重").data(weightsData)])
    }
}
