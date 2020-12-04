//
//  WeightData.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import Foundation

struct ChartData {
    
    var datas: [Any]?
    var min: Double?
    var max: Double?
    var categories: [String]?
}

struct DailyData {
    
    var weight: Double?
    var photo: Photo?
    var note: String?
}

struct Photo {
    
    var url: String
    var isFavorite: Bool
}
