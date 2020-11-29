//
//  DateProvider.swift
//  SimpleFit
//
//  Created by shuo on 2020/11/29.
//

import UIKit

class DateProvider {
    
    enum ChineseDay {

        case sun
        case mon
        case tue
        case wed
        case thu
        case fri
        case sat

        var day: String {

            switch self {
            case .sun: return "週日"
            case .mon: return "週一"
            case .tue: return "週二"
            case .wed: return "週三"
            case .thu: return "週四"
            case .fri: return "週五"
            case .sat: return "週六"
            }
        }
    }
    
    static let chineseDays: [ChineseDay] = [.sun, .mon, .tue, .wed, .thu, .fri, .sat]
    
    static func currentYear() -> Int {
        
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: Date())
        return com.year!
    }
    
    static func currentMonth() -> Int {
        
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: Date())
        return com.month!
    }
    
    static func currentDay() -> Int {
        
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: Date())
        return com.day!
    }
    
    static func currentWeekDay() -> Int {
        
        let interval = Int(Date().timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday == 0 ? 7 : weekday
    }
    
    static func countOfDaysInCurrentMonth() -> Int {
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: Date())
        return (range?.length)!
    }
    
    static func firstWeekDayInCurrentMonth() -> Int {
        
        //星期和數字一一對應 星期日：7
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: String(Date().year())+"-"+String(Date().month()))
        let calender = Calendar(identifier: Calendar.Identifier.gregorian)
        let comps = (calender as NSCalendar?)?.components(NSCalendar.Unit.weekday, from: date!)
        var week = comps?.weekday
        if week == 1 { week = 8 }
        return week! - 1
    }
    
    static func getCountOfDaysInMonth(year: Int, month: Int) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date
            = dateFormatter.date(from: String(year)+"-"+String(month))
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date!)
        return (range?.length)!
    }
    
    static func getfirstWeekDayInMonth(year: Int, month: Int) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: String(year)+"-"+String(month))
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let comps = (calendar as NSCalendar?)?.components(NSCalendar.Unit.weekday, from: date!)
        let week = comps?.weekday
        return week! - 1
    }
    
    static func add0BeforeNumber(_ number: Int) -> String {

        return number >= 10 ? String(number) : "0\(number)"
    }
}
