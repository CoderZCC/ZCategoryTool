//
//  UIColor+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 随机色
    class var k_randomColor: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// rbg颜色
    ///
    /// - Parameters:
    ///   - rgb: 一个大于1的数 [0,255.0]
    ///   - alpha: 透明度 0.0~1.0
    /// - Returns: 新颜色
    class func k_colorWith(rgb: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        
        return UIColor(red: rgb / 255.0, green: rgb / 255.0, blue: rgb / 255.0, alpha: alpha)
    }
    
    /// rbg颜色
    ///
    /// - Parameters:
    ///   - r: 一个大于1的数 [0,255.0]
    ///   - g: 一个大于1的数 [0,255.0]
    ///   - b: 一个大于1的数 [0,255.0]
    ///   - alpha: 透明度 0.0~1.0
    /// - Returns: 新颜色
    class func k_colorWith(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        
        return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 16进制颜色转为RGB颜色
    ///
    /// - Parameters:
    ///   - hexInt: 0x333333
    ///   - alpha: 透明度 默认 1.0
    /// - Returns: 颜色
    class func k_colorWith(hexInt: Int, alpha: CGFloat = 1.0) -> UIColor {
        let r = CGFloat((hexInt & 0xFF0000) >> 16)
        let g = CGFloat((hexInt & 0x00FF00) >> 8)
        let b = CGFloat((hexInt & 0x0000FF))
        
        return UIColor.k_colorWith(r: r, g: g, b: b, alpha: alpha)
    }
    
    /// 16进制颜色转为RGB颜色
    ///
    /// - Parameter hexStr: 0x333333 / #333333
    /// - Returns: 颜色
    class func k_colorWith(hexStr: String, alpha: CGFloat = 1.0) -> UIColor{
        var cstr = hexStr.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        if (cstr.length < 6) {
            
            return UIColor.clear;
        }
        if (cstr.hasPrefix("0X")) {
            
            cstr = cstr.substring(from: 2) as NSString
        }
        if (cstr.hasPrefix("#")) {
            
            cstr = cstr.substring(from: 1) as NSString
        }
        if (cstr.length != 6) {
            
            return UIColor.clear;
        }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range);
        //g
        range.location = 2;
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4;
        let bStr = cstr.substring(with: range)
        var r: UInt32 = 0x0;
        var g: UInt32 = 0x0;
        var b: UInt32 = 0x0;
        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        return UIColor.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha);
    }
}

