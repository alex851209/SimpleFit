//
//  WeightData.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/28.
//

import Foundation

struct ChartData {
    
    var datas: [Double?]?
    var clearDatas: [Any?]?
    var min: Double?
    var max: Double?
    var categories: [String]?
}

struct DailyData: Codable, Equatable {
    
    var weight: Double?
    var photo: Photo?
    var note: String?
    var month: String = ""
    var day: String = ""
    var date: String = ""
}

struct Photo: Codable, Equatable {
    
    var url: String
    var isFavorite: Bool
}
