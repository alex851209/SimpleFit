//
//  Double+Ext.swift
//  SimpleFit
//
//  Created by shuo on 2020/12/11.
//

import Foundation

extension Double {
    
    func round(to places: Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
