//
//  Number+Ext.swift
//  HmmProject
//
//  Created by ZCC on 2018/10/29.
//  Copyright © 2018 Hmm. All rights reserved.
//

import UIKit

extension Int {
    
    /// 格林什么时间格式
    ///
    /// - Returns: 时间
    public func k_toHMS() -> String {
        var newStr: String = "PT"
        
        let hour = self / 3600
        let min = (self % 3600) / 60
        let sec = self % 60
        if hour != 0 {
            newStr += "\(hour)H"
        }
        if min != 0 {
            newStr += "\(min)M"
        }
        if sec != 0 {
            newStr += "\(sec)S"
        }
        return newStr == "PT" ? "PT0S" : newStr
    }
}
