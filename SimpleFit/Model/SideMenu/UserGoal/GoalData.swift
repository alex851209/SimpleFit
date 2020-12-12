//
//  GoalData.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/12.
//

import Foundation

struct Goal: Codable {
    
    var title: String = ""
    var beginDate: String = ""
    var endDate: String = ""
    var beginWeight: Double = 0
    var endWeight: Double = 0
}
