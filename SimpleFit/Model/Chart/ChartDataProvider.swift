//
//  ChartDataProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import Foundation

class ChartDataProvider {
    
    var chartData = ChartData()
    
    func getData() -> ChartData {
        
        getWeight()
        getCategories()
        return chartData
    }
    
    private func getWeight() {
        
        let weights = [
            63.2, 62.9, nil, nil, nil, 62.5, 64.2, 62.5, 62.3, 63.3, 62.9, 63.6,
            63.2, 62.9, 63.5, 64.0, 62.2, 63.5, 64.2, 64.5, 64.3, 64.3, 64.9, 64.6,
            63.2, 62.9, 62.5, 64.5, 62.2, 63.5
        ]
        var datas = [Any]()
        
        for xPosition in 0 ..< weights.count {
            guard let yPosition = weights[xPosition] else { continue }
            let coordinates: [Any] = [xPosition, yPosition]
            datas.append(coordinates)
        }
        
        guard let min = weights.compactMap({ $0 }).min(),
              let max = weights.compactMap({ $0 }).max()
        else { return }
        
        chartData.datas = datas
        chartData.min = min - 5
        chartData.max = max + 5
    }
    
    private func getCategories() {
        
        let currentYear = DateProvider.currentYear()
        let currentMonth = DateProvider.currentMonth()
        let countOfDays = DateProvider.getCountOfDaysInMonth(year: currentYear, month: currentMonth)
        var firstDay = DateProvider.getfirstWeekDayInMonth(year: currentYear, month: currentMonth)
        var categories = [String]()
        
        for count in 1 ... countOfDays {
            
            let date = DateProvider.add0BeforeNumber(count)
            let chineseDay = DateProvider.chineseDays[firstDay].day
            let category = "\(chineseDay)<br>\(date)"
            
            firstDay += firstDay != 6 ? 1 : -6
            categories.append(category)
        }
        
        chartData.categories = categories
    }
}
