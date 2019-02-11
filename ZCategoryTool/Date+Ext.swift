//
//  Date+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

//MARK: 日期相关
extension Date {
    
    //MARK: 指定日期 多加x小时
    /// 指定日期 多加x小时
    ///
    /// - Parameter num: 添加的小时数
    /// - Returns: 新时间
    func k_addingHours(_ num: Int) -> Date {
        
        return self.addingTimeInterval(TimeInterval(60.0 * 60.0 * CGFloat(num)))
    }

    //MARK: 获取时间月份有几天
    /// 获取时间月份有几天
    ///
    /// - Returns: 天数
    func k_getDaysInMonth() -> Int {
        
        let component = self.k_YMDHMS()
        let year = component.year!
        let month = component.month!
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.year = year
        startComps.month = month
        
        var endComps = DateComponents()
        endComps.day = 1
        endComps.year = (month == 12 ? (year + 1) : (year))
        endComps.month = (month == 12 ? (1) : (month + 1))
        
        let calendar = Calendar.current
        let startDate = calendar.date(from: startComps)!
        let endDate = calendar.date(from: endComps)!
        
        let diff = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return diff.day!
    }
    
    //MARK: 指定日期的 年月日时分秒
    /// 指定日期的 年月日时分秒
    ///
    /// - Returns: DateComponents.year...
    func k_YMDHMS() -> DateComponents {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let compent = calendar.dateComponents([.year, .day, .month, .hour, .minute, .second], from: self)
        
        return compent
    }
    
    //MARK: 是否是今年
    /// 是否是同今年
    ///
    /// - Parameter otherDate: 其他日期
    /// - Returns: 结果
    func k_isThisYear(otherDate: Date) -> Bool {

        /// 当前时间的年月日
        let nowCompent = Date().k_YMDHMS()
        /// self的年月日
        let selfCompent = self.k_YMDHMS()
        
        return nowCompent.year! == selfCompent.year!
    }
    
    //MARK: 是否是今月
    /// 是否是同今月
    ///
    /// - Parameter otherDate: 其他日期
    /// - Returns: 结果
    func k_isThisMonth(otherDate: Date) -> Bool {
        
        /// 当前时间的年月日
        let nowCompent = Date().k_YMDHMS()
        /// self的年月日
        let selfCompent = self.k_YMDHMS()
        
        return (nowCompent.year! == selfCompent.year!) && (nowCompent.month! == selfCompent.month!)
    }
    
    //MARK: 是否是今天
    /// 是否是今天
    ///
    /// - Parameter otherDate: 其他日期
    /// - Returns: 结果
    func k_isThisDay(otherDate: Date) -> Bool {

        /// 当前时间的年月日
        let nowCompent = Date().k_YMDHMS()
        /// self的年月日
        let selfCompent = self.k_YMDHMS()
        
        return (nowCompent.year! == selfCompent.year!) && (nowCompent.month! == selfCompent.month!) && (nowCompent.day! == selfCompent.day!)
    }
    
    //MARK: 指定日期是 星期几
    /// 指定日期是 星期几
    ///
    /// - Returns: 星期一..日
    func k_weekDay() -> String {
        let dataDic: [Int: String] = [1: "星期天", 2: "星期一", 3: "星期二", 4: "星期三", 5: "星期四", 6: "星期五", 7: "星期六"]
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let compent = calendar.dateComponents([.weekday], from: self)
        
        return dataDic[compent.weekday!]!
    }
    
    //MARK: 指定日期转为字符串(不用在Date + 8小时)
    /// 指定日期转为字符串(不用在Date + 8小时)
    ///
    /// - Parameter formatter: 格式 默认 yyyy-MM-dd HH:mm:ss
    /// - Returns: 时间字符串
    func k_toDateStr(_ formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let fat = DateFormatter.init()
        fat.timeZone = TimeZone.current
        
        fat.dateFormat = formatter
        let str = fat.string(from: self)
        
        return str
    }
    
    //MARK: 日期比较大小
    /// 日期比较大小
    ///
    /// - Parameter otherDate: 其他日期
    /// - Returns: 结果 0: 相等; 1: otherTime大; 2: otherTime小
    func k_compareToDate(_ otherDate: Date) -> Int {
        let resultDic: [ComparisonResult: Int] = [.orderedSame: 0, .orderedAscending: 1, .orderedDescending: 2]
        let result: ComparisonResult = self.compare(otherDate)
        
        return resultDic[result]!
    }
}
