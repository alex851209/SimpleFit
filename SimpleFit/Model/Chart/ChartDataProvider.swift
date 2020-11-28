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
        
        let categories = [
            "週一<br>01", "週二<br>02", "週三<br>03", "週四<br>04", "週五<br>05", "週六<br>06", "週日<br>07",
            "週一<br>08", "週二<br>09", "週三<br>10", "週四<br>11", "週五<br>12", "週六<br>13", "週日<br>14",
            "週一<br>15", "週二<br>16", "週三<br>17", "週四<br>18", "週五<br>19", "週六<br>20", "週日<br>21",
            "週一<br>22", "週二<br>23", "週三<br>24", "週四<br>25", "週五<br>26", "週六<br>27", "週日<br>28",
            "週一<br>29", "週二<br>30"
        ]
        chartData.categories = categories
    }
}
