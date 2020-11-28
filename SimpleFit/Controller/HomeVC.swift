//
//  ViewController.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/26.
//

import UIKit
import AAInfographics
import SideMenu

class HomeVC: UIViewController {
    
    private struct Segue {
        
        static let sideMenuNC = "SegueSideMenuNC"
    }
    
    let chartView = AAChartView()
    var chartModel = AAChartModel()
    var chartOptions = AAOptions()
    let dataProvider = ChartDataProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNC()
        configureChart()
        configureSideMenu()
    }
    
    private func configureLayout() {
        
        let sideMenuButton = UIButton()
        sideMenuButton.setImage(UIImage.systemAsset(.sideMenu), for: .normal)
        sideMenuButton.tintColor = .gray
        sideMenuButton.contentHorizontalAlignment = .fill
        sideMenuButton.contentVerticalAlignment = .fill
        sideMenuButton.addTarget(self, action: #selector(showSideMenu), for: .touchUpInside)
        
        let monthLabel = UILabel()
        monthLabel.text = "11月"
        monthLabel.textColor = .systemGray
        monthLabel.font = .systemFont(ofSize: 40)
        
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        sideMenuButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sideMenuButton)
        view.addSubview(monthLabel)
        
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            monthLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            sideMenuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            sideMenuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sideMenuButton.widthAnchor.constraint(equalToConstant: 30),
            sideMenuButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureNC() { navigationController?.navigationBar.isHidden = true }
    
    private func configureChart() {
        
        configureChartModel()
        configureChartView()
        chartView.aa_drawChartWithChartOptions(chartOptions)//圖表視圖對象調用圖表模型對象,繪制最終圖形
    }
    
    private func configureChartView() {
        
        let chartViewWidth  = view.frame.size.width
        let chartViewHeight = view.frame.size.height - 80
        chartView.frame = CGRect(x: 0, y: 0, width: chartViewWidth, height: chartViewHeight)
        view.addSubview(chartView)
    }
    
    private func configureChartModel() {
        
        let chartData = dataProvider.getData()
        
        guard let min = chartData.min,
              let max = chartData.max,
              let categories = chartData.categories,
              let weightsData = chartData.datas
        else { return }
        
        chartModel = AAChartModel()
            .animationDuration(1200)
            .categories(categories)
            .chartType(.spline)//圖表類型
            .colorsTheme(["#c0c0c0"])
            .dataLabelsEnabled(true)//數據標簽是否顯示
            .dataLabelsFontColor("gray")
            .dataLabelsFontSize(18)
            .dataLabelsFontWeight(.bold)
            .inverted(false)//是否翻轉圖形
            .legendEnabled(false)//是否啟用圖表的圖例(圖表底部的可點擊的小圓點)
            .markerRadius(10)//連接點大小
            .markerSymbolStyle(.borderBlank)//折線或者曲線的連接點是否為空心的
            .scrollablePlotArea(AAScrollablePlotArea().minWidth(2000).scrollPositionX(0))
            .series([AASeriesElement().name("體重").data(weightsData)])
//            .subtitle("2020年11月")//圖表副標題
//            .title("Simple Fit")//圖表主標題
            .tooltipValueSuffix("公斤")//浮動提示框單位後綴
            .tooltipEnabled(true)//是否顯示浮動提示框
            .touchEventEnabled(true)//是否支持觸摸事件回調
            .yAxisLabelsEnabled(false)//y 軸是否顯示數據
            .yAxisMin(min)
            .yAxisMax(max)
        
        let crosshair = AACrosshair().width(0.01)
        chartOptions = chartModel.aa_toAAOptions()
        chartOptions.xAxis?.crosshair(crosshair)
    }
    
    private func configureSideMenu() {
        
        let sideMenuNC = storyboard?.instantiateViewController(withIdentifier: "SideMenuNC")
        SideMenuManager.default.rightMenuNavigationController = sideMenuNC as? SideMenuNavigationController
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        SideMenuManager.default.rightMenuNavigationController?.settings = makeSettings()
        configureLayout()
    }
    
    @objc private func showSideMenu() { performSegue(withIdentifier: Segue.sideMenuNC, sender: nil) }
    
    private func makeSettings() -> SideMenuSettings {
        
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.backgroundColor = .clear
        presentationStyle.menuStartAlpha = 0.1
        presentationStyle.presentingEndAlpha = 0.8
        presentationStyle.onTopShadowOpacity = 0.5
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.presentDuration = 1
        settings.dismissDuration = 1
        settings.blurEffectStyle = .extraLight
        settings.menuWidth = view.frame.width - 100

        return settings
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let sideMenuNC = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNC.settings = makeSettings()
    }
}
