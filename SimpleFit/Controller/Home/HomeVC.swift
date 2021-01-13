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
    
    static let identifier = "HomeVC"
    
    private struct Segue {
        
        static let sideMenuNC = "SegueSideMenuNC"
        static let datePicker = "SegueDatePicker"
        static let daily = "SegueDaily"
        static let addWeight = "SegueAddWeight"
        static let addNote = "SegueAddNote"
        static let addPhoto = "SegueAddPhoto"
    }
    
    let chartView = AAChartView()
    var chartModel = AAChartModel()
    var chartOptions = AAOptions()
    let addMenuView = AddMenuView()
    let provider = ChartProvider()
    var selectedYear = Date().year()
    var selectedMonth = Date().month()
    let pickMonthButton = UIButton()
    let sideMenuButton = UIButton()
    var selectedPhoto = UIImage()
    var dailys = [DailyData]()
    var selectedDaily = DailyData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNC()
        configureChartWith(year: selectedYear, month: selectedMonth)
        configureSideMenu()
    }
    
    private func configureButton() {
        
        sideMenuButton.setImage(UIImage.asset(.sideMenu), for: .normal)
        sideMenuButton.addTarget(self, action: #selector(showSideMenu), for: .touchUpInside)
        
        pickMonthButton.addTarget(self, action: #selector(showPickMonthPage), for: .touchUpInside)
        
        view.insertSubview(pickMonthButton, aboveSubview: chartView)
        view.insertSubview(sideMenuButton, aboveSubview: chartView)
        
        sideMenuButton.applySideMenuButton()
        pickMonthButton.applyPickMonthButtonFor(month: selectedMonth)
    }
    
    private func configureAddMenu() {
        
        addMenuView.delegate = self
        addMenuView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(addMenuView)
    }
    
    private func configureChartWith(year: Int, month: Int) {
        
        provider.fetchDailyDatasFrom(year: year, month: month) { [weak self] (result) in
            switch result {
            case .success(let dailys):
                self?.selectedYear = year
                self?.selectedMonth = month
                self?.pickMonthButton.setTitle("\(month)月", for: .normal)
                
                self?.configureAddMenu()
                self?.configureChartModel()
                self?.configureChartView()
                self?.configureButton()
                
                guard let chartOptions = self?.chartOptions else { return }
                self?.chartView.aa_drawChartWithChartOptions(chartOptions)
                self?.dailys = dailys
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureNC() { navigationController?.navigationBar.isHidden = true }
    
    private func configureChartView() {
        
        let chartViewWidth  = view.frame.size.width
        let chartViewHeight = view.frame.size.height - 80
        
        chartView.frame = CGRect(x: 0, y: 0, width: chartViewWidth, height: chartViewHeight)
        chartView.delegate = self
        chartView.scrollEnabled = false
        chartView.isClearBackgroundColor = true
        
        view.insertSubview(chartView, belowSubview: addMenuView)
    }
    
    private func configureChartModel() {
        
        let chartData = provider.getDataFrom(year: selectedYear, month: selectedMonth)
        
        guard let min = chartData.min,
              let max = chartData.max,
              let categories = chartData.categories,
              let weightsDatas = chartData.datas,
              let clearDatas = chartData.clearDatas
        else { return }
        
        chartModel = AAChartModel()
            .animationDuration(500)
            .categories(categories)
            .chartType(.spline)// 圖表類型
            .colorsTheme(["#c0c0c0"])
            .dataLabelsEnabled(true)// 數據標簽是否顯示
            .dataLabelsFontColor("gray")
            .dataLabelsFontSize(18)
            .dataLabelsFontWeight(.bold)
            .inverted(false)// 是否翻轉圖形
            .legendEnabled(false)// 是否啟用圖表的圖例(圖表底部的可點擊的小圓點)
            .markerRadius(10)// 連接點大小
            .markerSymbolStyle(.borderBlank)// 折線或者曲線的連接點是否為空心
            .scrollablePlotArea(AAScrollablePlotArea().minWidth(2000).scrollPositionX(0))
            .series([
                AASeriesElement().name("體重").data(weightsDatas as [Any]),
                AASeriesElement().data(clearDatas as [Any])
            ])
            .tooltipValueSuffix("公斤")// 浮動提示框單位後綴
            .tooltipEnabled(false)// 是否顯示浮動提示框
            .touchEventEnabled(true)// 是否支持觸摸事件回調
            .yAxisLabelsEnabled(false)// y 軸是否顯示數據
            .yAxisMin(min)
            .yAxisMax(max)
        
        let crosshair = AACrosshair().width(0.01)
        chartOptions = chartModel.aa_toAAOptions()
        chartOptions.plotOptions?.series?.connectNulls(true)
        chartOptions.xAxis?.crosshair(crosshair)
    }
    
    private func configureSideMenu() {
        
        let sideMenuNC = storyboard?.instantiateViewController(withIdentifier: "SideMenuNC")
        SideMenuManager.default.leftMenuNavigationController = sideMenuNC as? SideMenuNavigationController
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
        SideMenuManager.default.leftMenuNavigationController?.settings = makeSettings()
    }
    
    private func showImagePicker(type: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func showSideMenu() {
        
        sideMenuButton.showButtonFeedbackAnimation { [weak self] in
            self?.performSegue(withIdentifier: Segue.sideMenuNC, sender: nil)
        }
    }
    
    @objc private func showPickMonthPage() {
        
        pickMonthButton.showButtonFeedbackAnimation { [weak self] in
            self?.performSegue(withIdentifier: Segue.datePicker, sender: nil)
        }
    }
    
    private func makeSettings() -> SideMenuSettings {
        
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.menuStartAlpha = 0.1
        presentationStyle.presentingEndAlpha = 0.8
        presentationStyle.onTopShadowOpacity = 0.5
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.presentDuration = 0.7
        settings.dismissDuration = 0.5
        settings.blurEffectStyle = .systemChromeMaterial
        settings.menuWidth = view.frame.width - 135

        return settings
    }
    
    private func configureSelectedDaily(with dayString: String) {

        dailys.forEach { if dayString.contains($0.day) { selectedDaily = $0 } }
    }
    
    private func updateChart() -> (Int, Int) -> Void {
        
        return { [weak self] (selectedYear, selectedMonth) in
            let isSameMonth = self?.selectedYear == selectedYear && self?.selectedMonth == selectedMonth
            if isSameMonth { self?.configureChartWith(year: selectedYear, month: selectedMonth) }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case Segue.sideMenuNC:
            guard let sideMenuNC = segue.destination as? SideMenuNavigationController else { return }
            sideMenuNC.settings = makeSettings()
        case Segue.daily:
            guard let dailyVC = segue.destination as? DailyVC else { return }
            dailyVC.dailys = dailys
            dailyVC.selectedDaily = selectedDaily
            dailyVC.callback = { (isFavorite, index) in
                self.dailys[index].photo?.isFavorite = isFavorite
            }
            dailyVC.removeDailyCallback = { [weak self] in
                guard let selectedYear = self?.selectedYear,
                      let selectedMonth = self?.selectedMonth
                else { return }
                
                self?.configureChartWith(year: selectedYear, month: selectedMonth)
            }
        case Segue.datePicker:
            guard let datePickerVC = segue.destination as? DatePickerVC else { return }
            datePickerVC.selectedYear = self.selectedYear
            datePickerVC.selectedMonth = self.selectedMonth
            datePickerVC.callback = { [weak self] (selectedYear, selectedMonth) in
                let isDifferentDate = self?.selectedYear != selectedYear || self?.selectedMonth != selectedMonth
                if isDifferentDate { self?.configureChartWith(year: selectedYear, month: selectedMonth) }
            }
        case Segue.addWeight:
            guard let addWeightVC = segue.destination as? AddWeightVC else { return }
            addWeightVC.callback = updateChart()
        case Segue.addNote:
            guard let addNoteVC = segue.destination as? AddNoteVC else { return }
            addNoteVC.callback = updateChart()
        case Segue.addPhoto:
            guard let addPhotoVC = segue.destination as? AddPhotoVC else { return }
            addPhotoVC.selectedPhoto = selectedPhoto
            addPhotoVC.callback = updateChart()
        default: break
        }
    }
}

extension HomeVC: AddMenuViewDelegate {
    
    func showAddWeight() { performSegue(withIdentifier: Segue.addWeight, sender: nil) }
    
    func showCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) { showImagePicker(type: .camera) }
    }
    
    func showAlbum() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) { showImagePicker(type: .photoLibrary) }
    }
    
    func showAddNote() { performSegue(withIdentifier: Segue.addNote, sender: nil) }
}

extension HomeVC: AAChartViewDelegate {
    
    func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
        
        guard let selectedDay = moveOverEventMessage.category else { return }
        configureSelectedDaily(with: selectedDay)
        performSegue(withIdentifier: Segue.daily, sender: nil)
    }
}

extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        
        guard let selectedPhoto = info[.editedImage] as? UIImage else { return }
        self.selectedPhoto = selectedPhoto
        
        dismiss(animated: true) { [weak self] in
            self?.performSegue(withIdentifier: Segue.addPhoto, sender: nil)
        }
    }
}
