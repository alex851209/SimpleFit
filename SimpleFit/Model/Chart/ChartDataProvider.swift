//
//  ChartDataProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import Foundation

class ChartDataProvider {
    
    var chartData = ChartData()
    
    func getDataFor(year: Int, month: Int) -> ChartData {
        
        getWeightFor(year: year, month: month)
        getCategoriesFor(year: year, month: month)
        return chartData
    }
    
    private func getWeightFor(year: Int, month: Int) {
        
        let oddWeights = [
            63.2, 62.9, nil, nil, 63.0, 62.5, 64.2, 62.5, 62.3, 63.3, 62.9, 63.6,
            63.2, 62.9, 63.5, 64.0, 62.2, 63.5, 64.2, 64.5, 64.3, 64.3, 64.9, 64.6,
            63.2, 62.9, 62.5, 64.5, 62.2, 63.5
        ]
        
        let evenWeights = [
            65.2, 64.9, 65.1, 65.1, 65.0, 65.5, 65.2, 65.5, 65.3, 65.3, 65.6, 65.8,
            65.5, 65.6, 65.5, 65.9, 66.0, 65.8, 66.1, 66.2, 65.9, 66.3, 66.3, 66.6,
            66.2, 66.0, 66.3, 66.5, 66.3, 66.5, 66.8
        ]

        var weights = [Double?]()
        
        switch month % 2 {
        
        case 0: weights = evenWeights
        case 1: weights = oddWeights
        default: break
        }
        
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
    
    private func getCategoriesFor(year: Int, month: Int) {
        
        let countOfDays = DateProvider.getCountOfDaysInMonth(year: year, month: month)
        var firstDay = DateProvider.getfirstWeekDayInMonth(year: year, month: month)
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
