//
//  Date+Ext.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/29.
//

import UIKit

extension Date {

    func year() -> Int {
        
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: self)
        return com.year!
    }

    func month() -> Int {

        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: self)
        return com.month!
    }

    func day() -> Int {

        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: self)
        return com.day!
    }
}
