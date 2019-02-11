//
//  Number+Ext.swift
//  HmmProject
//
//  Created by 张崇超 on 2018/10/29.
//  Copyright © 2018 Hmm. All rights reserved.
//

import UIKit

extension Int {
    
    /// 格林什么时间格式
    ///
    /// - Returns: 时间
    func k_toHMS() -> String {
        let nd = 24.0 * 60.0 * 60.0
        let nh = 60.0 * 60.0
        let nm = 60.0
        
        let doubleValue = Double(self)
        var newStr: String = "PT"
        
        let hour = Int(doubleValue.truncatingRemainder(dividingBy: nd) / nh)
        let min = Int(doubleValue.truncatingRemainder(dividingBy: nd).truncatingRemainder(dividingBy: nh) / nm)
        let sec = Int(doubleValue.truncatingRemainder(dividingBy: nd).truncatingRemainder(dividingBy: nh).truncatingRemainder(dividingBy: nm))
        
        if hour != 0 {
            
            newStr += "\(hour)H"
        }
        if min != 0 {
            
            newStr += "\(min)M"
        }
        if sec != 0 {
            
            newStr += "\(sec)S"
        }
        
        return newStr
    }
}

extension TimeInterval {
    
    /// 处理为 00:00格式
    ///
    /// - Returns: 00:00
    func k_dealString() -> String {
        
        if self.isNaN {
            return "00:00"
        }
        let minute = Int(self / 60.0)
        let second = Int(self.truncatingRemainder(dividingBy: 60.0))
        
        return "\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
    }
}
