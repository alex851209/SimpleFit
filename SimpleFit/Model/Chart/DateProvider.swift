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
    
    static let formatter = DateFormatter()
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
        let range = (calendar as NSCalendar?)?.range(
            of: NSCalendar.Unit.day,
            in: NSCalendar.Unit.month,
            for: Date())
        return (range?.length)!
    }
    
    static func firstWeekDayInCurrentMonth() -> Int {
        
        // 星期和數字一一對應 星期日：7
        formatter.dateFormat = "yyyy-MM"
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        let date = formatter.date(from: String(Date().year())+"-"+String(Date().month()))
        let calender = Calendar(identifier: Calendar.Identifier.gregorian)
        let comps = (calender as NSCalendar?)?.components(NSCalendar.Unit.weekday, from: date!)
        var week = comps?.weekday
        if week == 1 { week = 8 }
        return week! - 1
    }
    
    static func getCountOfDaysInMonth(year: Int, month: Int) -> Int {
        
        formatter.dateFormat = "yyyy-MM"
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        let date = formatter.date(from: String(year)+"-"+String(month))
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(
            of: NSCalendar.Unit.day,
            in: NSCalendar.Unit.month,
            for: date!)
        return (range?.length)!
    }
    
    static func getfirstWeekDayInMonth(year: Int, month: Int) -> Int {
        
        formatter.dateFormat = "yyyy-MM"
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        let date = formatter.date(from: String(year)+"-"+String(month))
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let comps = (calendar as NSCalendar?)?.components(NSCalendar.Unit.weekday, from: date!)
        let week = comps?.weekday
        return week! - 1
    }
    
    static func add0BeforeNumber(_ number: Int) -> String {

        return number >= 10 ? String(number) : "0\(number)"
    }
    
    static func dateStringToDate(_ dateStr: String) -> Date {
        
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateStr)
        return date!
    }

    static func dateToDateString(_ date: Date) -> String {
        
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: date)
        return date
    }
    
    static func dateToMonthString(_ date: Date) -> String {
        
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "yyyy-MM"
        let date = formatter.string(from: date)
        return date
    }
    
    static func dateToDayString(_ date: Date) -> String {
        
        formatter.locale = Locale(identifier: "zh_Hant_TW")
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        formatter.dateFormat = "dd"
        let date = formatter.string(from: date)
        return date
    }
    
    static func getLastMonth(_ date: Date) -> Date {
        
        var dateComponent = DateComponents()
        dateComponent.month = -1
        guard let lastMonth = Calendar.current.date(byAdding: dateComponent, to: date)
        else { return date }
        
        return lastMonth
    }
    
    static func getNextMonth() -> Date {
        
        var dateComponent = DateComponents()
        dateComponent.month = 1
        guard let nextMonth = Calendar.current.date(byAdding: dateComponent, to: Date())
        else { return Date() }
        
        return nextMonth
    }
}
