//
//  DFWDateExtension.swift
//  DongFuWang
//
//  Created by qianduan2730 on 2020/12/1.
//

import Foundation
///与服务器的时间差
let KServerTimeDiffer = "KServerTimeDiffer"

extension Date {
    
    private static var calendar: Calendar  {
        let calendar = Calendar.current
        return calendar
    }
    
    public static func getDate(y: Int, m: Int = 1, d: Int = 1) -> Date? {
        let dateString = String.init(format: "%04d-%02d-%02d", y,m,d)
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd"
        format.timeZone = self.calendar.timeZone
        let date = format.date(from: dateString)
        return date
    }
    ///时间字符串转date
    public static func dateFrom(_ dateString: String, _ formatString: String) -> Date? {
        let format = DateFormatter.init()
        format.dateFormat = formatString
        let date = format.date(from: dateString)
        return date
    }
    ///时间字符串转时间戳
    public static func timeStrToTimeInterval(timeStr:String, dataFormat:String) -> Double {
        if timeStr.count == 0 {
            return 0
        }
        let format = DateFormatter.init()
        format.dateFormat = dataFormat
        if let date = format.date(from: timeStr) {
            return date.timeIntervalSince1970
        }else {
            return 0
        }
        
    }
    ///时间戳转date
    public static func getDateFromTimeStamp(timeStamp:Double) ->Date {
        let interval:TimeInterval = timeStamp
        return Date(timeIntervalSince1970: interval)
    }
    //时间戳转时间字符串
    public static func timeIntervalToTimeStr(timeInterval:Double, dataFormat:String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dataFormat// 自定义时间格式
          // GMT时间 转字符串，直接是系统当前时间
        return dateformatter.string(from: Date(timeIntervalSince1970: timeInterval))
        
    }
    ///是否为同一天
    public static func isSameToday(date1:Date,date2:Date) -> Bool {
        let calendar = Calendar.current
        let comp1 = calendar.dateComponents([.year,.month,.day], from: date1)
        let comp2 = calendar.dateComponents([.year,.month,.day], from: date2)
        //开始比较
        if comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day {
             print ( "它们是同一天" )
            return true
        }else{
            print ( "它们不是同一天" )
            return false
        }
    }
    
    
    public func getYear() -> Int {
        let components = Date.calendar.dateComponents([.year,.month,.day], from: self)
        guard let year = components.year else {
            return 1
        }
        return year
    }
    
    public func getMonth() -> Int {
        let components = Date.calendar.dateComponents([.year,.month,.day], from: self)
        guard let month = components.month else {
            return 1
        }
        return month
    }
    
    public func getDay() -> Int {
        let components = Date.calendar.dateComponents([.year,.month,.day], from: self)
        guard let day = components.day else {
            return 1
        }
        return day
    }
    
    public func toString(_ formatString: String, locale: Locale? = nil) -> String {
        let format = DateFormatter.init()
        format.dateFormat = formatString
        if let l = locale {
            format.locale = l
        }
        let timeString = format.string(from: self)
        return timeString
    }
    
    public func toDaySince(_ date: Date) -> Int {
        let components = Self.calendar.dateComponents([.day], from: date, to: self)
        return abs(components.day ?? 0)
    }
    
    /// 获取当前时间-毫秒级
    /// - Returns: 时间
    public static func getCurrentTimeMillion() -> Int {
        let a: TimeInterval = Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970
        return Int(CLongLong(round(a*1000)))
    }
    
    /// 获取当前时间-秒级
    /// - Returns: 时间-秒
    public static func getCurrentTimeSecend() -> Int {
        let a: TimeInterval = Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970
        return Int(CLongLong(round(a)))
    }
    /// 获取当前时间 时分秒
    /// - Returns: 时间
    public static func getCurrentTime() -> String? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm:ss"// 自定义时间格式
          // GMT时间 转字符串，直接是系统当前时间
        return dateformatter.string(from: Date())
    }
    public static func getCurrentTimeWithBrisk() -> String? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"// 自定义时间格式
          // GMT时间 转字符串，直接是系统当前时间
        return dateformatter.string(from: Date())
    }
    /// 获取当前时间年月日时分秒
    /// - Returns: 时间
    public static func getCurrentTimeWithDay() -> String? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"// 自定义时间格式
          // GMT时间 转字符串，直接是系统当前时间
        return dateformatter.string(from: Date())
    }

    
    /// 时间戳转string
    /// - Parameter timeInterval: 时间戳
    /// - Returns: 时间
    public static func fromDateToString(timeInterval:Double) -> String {
        let date = Date.init(timeIntervalSince1970:timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"// 自定义时间格式
        return dateformatter.string(from: date)
    }
    ///< 获取当前时间的: 前一周(day:-7)丶前一个月(month:-30)丶前一年(year:-1)的时间戳
    public static func getExpectTimestamp(day:Int) -> Date {
        var datecomps = DateComponents.init()
        datecomps.day = day
        let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        let calculatedate = calendar?.date(byAdding: datecomps, to: Date(), options: NSCalendar.Options.init(rawValue: 0))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"// 自定义时间格式
        let calculateStr = formatter.string(from: calculatedate!)
        print(calculateStr)
        return calculatedate!
    }
    
    /// 获取服务器时间
    /// - Returns: 服务器时间
    public static func serverDate() -> Date{
        let localInterver : TimeInterval = Date().timeIntervalSince1970
        let differString = DFWUserDefault.getUserDefault(key: KServerTimeDiffer) ?? ""
        let differ :TimeInterval =  Double(differString) ?? 0.0
        let serverInterver :TimeInterval = localInterver+differ
        return Date.init(timeIntervalSince1970: serverInterver)
    }
}


extension Int {
    /// 时间戳转字符串
    /// - Parameters:
    ///   - isMs: 是否是毫秒
    ///   - mode: mode description
    /// - Returns: description
    func toStringTime(isMs: Bool = false, dateFormatter: String = "YYYY-MM-dd HH:mm:ss") -> String {
        let time = isMs ? self / 1000 : self
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormatter
        let dateString = dateformatter.string(from: date)
        return dateString
    }
}
