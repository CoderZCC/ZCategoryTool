//
//  Date+Ext.swift
//  ExtensionTool
//
//  Created by ZCC on 2018/7/10.
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
    public mutating func k_addingHours(_ num: Int) {
        self.addTimeInterval(TimeInterval(60.0 * 60.0 * CGFloat(num)))
    }
    
    //MARK: 获取时间月份有几天
    /// 获取时间月份有几天
    ///
    /// - Returns: 天数
    public func k_getDaysInMonth() -> Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)
        return range?.count ?? 1
    }
    
    //MARK: 指定日期的 年月日时分秒
    /// 指定日期的 年月日时分秒
    ///
    /// - Returns: DateComponents.year...
    public func k_YMDHMS() -> DateComponents {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return calendar.dateComponents([.year, .day, .month, .hour, .minute, .second], from: self)
    }
    
    //MARK: 指定日期是 星期几
    /// 指定日期是 星期几
    ///
    /// - Returns: 星期一..日
    public func k_weekDay() -> String {
        let dataDic: [Int: String] = [1: "星期天", 2: "星期一", 3: "星期二", 4: "星期三", 5: "星期四", 6: "星期五", 7: "星期六"]
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let compent = calendar.dateComponents([.weekday], from: self)
        return dataDic[compent.weekday ?? 0]!
    }
    
    //MARK: 指定日期转为字符串
    /// 指定日期转为字符串
    ///
    /// - Parameter formatter: 格式 默认 yyyy-MM-dd HH:mm:ss
    /// - Returns: 时间字符串
    public func k_toDateStr(_ formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let fat = DateFormatter()
        fat.timeZone = TimeZone.current
        var newDate = self
        let timeZone = NSTimeZone.system.secondsFromGMT(for: newDate)
        newDate.addTimeInterval(TimeInterval(timeZone))
        fat.dateFormat = formatter
        
        return fat.string(from: newDate)
    }
    
    //MARK: 日期比较大小
    /// 日期比较大小
    ///
    /// - Parameter otherDate: 其他日期
    /// - Returns: 结果 0: 相等; 1: otherTime大; 2: otherTime小
    public func k_compareToDate(_ otherDate: Date) -> Int {
        let resultDic: [ComparisonResult: Int] = [.orderedSame: 0, .orderedAscending: 1, .orderedDescending: 2]
        return resultDic[self.compare(otherDate)] ?? 0
    }
}
