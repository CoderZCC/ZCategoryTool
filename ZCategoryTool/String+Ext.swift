//
//  String+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

//MARK: 字符串相关
extension String {
    
    /// 字符串格式化所有参数 [key: value]
    public var k_paramaters: [String: String] {
        var dic: [String: String] = [:]
        let urlComponents = URLComponents.init(string: self)
        for obj in urlComponents?.queryItems ?? [] {
            dic[obj.name] = obj.value ?? ""
        }
        return dic
    }
    
    /// MD5加密 32位小写
    ///
    /// - Returns: 加密
    public func k_toMD5Str() -> String {
        
        let cStrl = cString(using: String.Encoding.utf8)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStrl, CC_LONG(strlen(cStrl!)), buffer)
        var md5String = "";
        for idx in 0...15 {
            
            let obcStrl = String.init(format: "%02x", buffer[idx])
            md5String.append(obcStrl)
        }
        free(buffer)
        
        return md5String
    }
    
    /// 手机号保护, 前三位展示,后四位 *(不足为 * )
    public var securePhoneStr: String {
        if self.k_isEmpty {
            return self
        }
        
        let headerStr = self.k_subText(to: 2)
        var moddleStr = "****"
        var footerStr: String!
        if self.count > 7 {
            footerStr = self.k_subText(from: 7, to: self.count - 1)
        } else {
            footerStr = ""
            moddleStr = ""
            for _ in 0..<(self.count - 3) {
                moddleStr += "*"
            }
        }
        return headerStr + moddleStr + footerStr
    }
    
    /// 获取GBK编码字节数 中文-2个 英文-1个
    public var byteCount: Int {
        let encoding = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        
        return self.lengthOfBytes(using: String.Encoding(rawValue: encoding))
    }
    
    /// 去除首尾空格
    ///
    /// - Returns: 字符串
    public func k_removeHeadAndFoot() -> String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    /// 转为URL
    ///
    /// - Returns: URL
    public func k_toURL() -> URL? {
        
        return URL(string: self)
    }
    
    //MARK: 裁剪字符串
    /// 裁剪字符串
    ///
    /// - Parameters:
    ///   - from: 开始位置 从0开始
    ///   - to: 结束位置 包含这个位置
    ///   var str: String = "0123456789"
    ///   str = str[1, 9]
    ///   输出: str = "123456789"
    /// - Returns: 新字符串
    public func k_subText(from: Int = 0, to: Int) -> String {
        if from > to { return self }
        
        let startIndex = self.startIndex
        let fromIndex = self.index(startIndex, offsetBy: max(min(from, self.count - 1), 0))
        let toIndex = self.index(startIndex, offsetBy: min(max(0, to), self.count - 1))
        
        return String(self[fromIndex ... toIndex])
    }
    
    //MARK: 裁剪字符串, 使用: str[0, 10]
    /// 裁剪字符串, 使用: str[0, 10]
    ///
    /// - Parameters:
    ///   - from: 开始位置 从0开始
    ///   - to: 结束位置 包含这个位置
    subscript(_ from: Int, _ to: Int) -> String {
        
        return self.k_subText(from: from, to: to)
    }
    
    //MARK: 替换指定区域的文字
    /// 替换指定区域的文字
    ///
    /// - Parameters:
    ///   - range: 需要替换的文字范围
    ///   - replaceStr: 替换的文字
    /// - Returns: 新字符串
    public func k_replaceStr(range: NSRange, replaceStr: String) -> String {
        var newStr: String = self
        if let range = Range.init(range, in: self) {
            
            newStr.replaceSubrange(range, with: replaceStr)
            
        } else {
            
            debugPrint("范围不正确")
        }
        return newStr
    }
    
    //MARK: 字符串转为日期
    /// 字符串转为日期
    ///
    /// - Parameters:
    ///   - dateStr: 字符串日期
    ///   - formatter: 字符串对应的日期格式
    ///   eg: dateStr: 2018 0908 11:20:23
    ///       formatter: yyyy MMdd HH:mm:ss
    /// - Returns: date
    public func k_toDate(formatter: String) -> Date {
        let fat = DateFormatter.init()
        fat.dateFormat = formatter
        var date = fat.date(from: self)
        // 会少8个小时
        date != nil ? (date!.addTimeInterval(60.0 * 60.0 * 8.0)) : (debugPrint("时间格式不对应:k_toDate"))
        
        return date ?? Date()
    }
    
    //MARK: 时间戳转为字符串
    /// 时间戳转为字符串
    ///
    /// - Parameters:
    ///   - timeStamp: 时间戳 10位/13位
    ///   - output: 输出格式 默认:yyyy年MM月dd日 HH:mm:ss
    /// - Returns: 日期字符串
    public static func k_timeStampToDateString(_ timeStamp: String, output: String = "yyyy年MM月dd日 HH:mm:ss") -> String {
        let newTimeStamp = timeStamp.count > 10 ? (timeStamp.k_subText(to: 9)): (timeStamp)
        let str = NSString.init(string: newTimeStamp)
        let doubleValue = str.doubleValue
        
        let fat = DateFormatter()
        fat.dateFormat = output
        
        return fat.string(from: Date.init(timeIntervalSince1970: doubleValue))
    }
    
    //MARK: 比较两个格式相同的时间大小
    /// 比较两个格式相同的时间大小
    ///
    /// - Parameter otherTime: 时间
    /// - Returns: 结果 0: 相等; 1: otherTime大; 2: otherTime小
    public func k_compareToStr(_ otherTime: String, formatter: String) -> Int {
        let resultDic: [ComparisonResult: Int] = [.orderedSame: 0, .orderedAscending: 1, .orderedDescending: 2]
        let t1 = self.k_toDate(formatter: formatter)
        let t2 = otherTime.k_toDate(formatter: formatter)
        
        return resultDic[t1.compare(t2)]!
    }
    
    //MARK: 指定时间转为特殊格式
    /// 指定时间转为特殊格式
    ///
    /// - Returns: 刚刚 / 几分钟前 / HH:mm / 昨天 HH:mm / MM-dd HH:mm / yyyy年MM-dd
    public func k_dealTimeToShow(formatter: String) -> String {
        // 当前的时间
        let nowDate = Date()
        // 传入的时间
        let fat = DateFormatter.init()
        fat.dateFormat = formatter
        let selfDate = fat.date(from: self)!
        // 比当前时间还大
        if selfDate.k_compareToDate(nowDate) == 2 {
            
            return "未知时间"
        }
        let selfCom = selfDate.k_YMDHMS()
        let nowCom = nowDate.k_YMDHMS()
        
        if selfCom.year != nowCom.year {
            
            // 年不相等
            return selfDate.k_toDateStr("yyyy年MM-dd")
        }
        if nowCom.day! - selfCom.day! == 1 {
            
            // 日不相等,差一天
            return selfDate.k_toDateStr("昨天 HH:mm")
        }
        if selfCom.day! != nowCom.day! {
            
            // 日不相等,差一天以上
            return selfDate.k_toDateStr("MM-dd HH:mm")
        }
        if selfCom.hour! != nowCom.hour! {
            
            // 时不相等
            return selfDate.k_toDateStr("今天 HH:mm")
        }
        if selfCom.minute! != nowCom.minute! {
            
            // 分不相等
            return "\(nowCom.minute! - selfCom.minute!)分钟前"
        }
        return "刚刚"
    }
    
    //MARK: caches路径
    /// caches路径
    public static var k_cachesPath: String {
        
        return NSHomeDirectory() + "/Library/Caches/"
    }
    
    //MARK: documents路径
    /// documents路径
    public static var k_documentsPath: String {
        
        return NSHomeDirectory() + "/Documents/"
    }
    
    //MARK: tmp路径
    /// tmp路径
    public static var k_tmpPath: String {
        
        return NSHomeDirectory() + "/tmp/"
    }
    
    //MARK: 转为Int
    /// 转为Int
    ///
    /// - Returns: Int
    public func k_toInt() -> Int? {
        
        return Int(self)
    }
    
    //MARK: 转为转为CGFloat
    /// 转为CGFloat
    ///
    /// - Returns: CGFloat
    public func k_toCGFloat() -> CGFloat {
        
        return CGFloat(Double(self) ?? 0.0)
    }
}

extension String {
    
    /// 是否包含Emoij
    ///
    /// - Returns: 是/否
    public func k_containsEmoij() -> Bool {
        
        if let regex = try? NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive) {
            
            return regex.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: self.count)).isEmpty
        }
        return false
    }
    
    /// 移除字符串中的Emoij
    ///
    /// - Returns: 新字符串
    public func k_deleteEmoij() -> String {
        
        if self.k_containsEmoij() {
            
            let regex = try! NSRegularExpression.init(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive)
            return regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: self.count), withTemplate: "")
        }
        return self
    }
    
    /// 是否为空, 全空格/empty
    ///
    /// - Returns: 是否
    public var k_isEmpty: Bool {
        if self.isEmpty {
            return true
        }
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    /// 是否符合邮箱规则
    public var k_isEmail: Bool {
        
        var count: Int = 0
        for chara in self {
            if chara == "@" {
                count += 1
            }
        }
        /// @只出现一次,包含@,不是空格, 并且不包含汉字
        return count == 1 && self.contains("@") && !self.k_isEmpty && !self.k_isHasChinese
    }
    
    /// 是否包含汉字
    public var k_isHasChinese: Bool {
        for chara in self {
            if chara >= "\u{4E00}" && chara <= "\u{9FA5}" {
                return true
            }
        }
        return false
    }
    
    /// 是否符合手机号码规则
    public var k_isPhoneNum: Bool {
        
        // 全是数字, 不是空格
        return !self.k_isEmpty && self.trimmingCharacters(in: CharacterSet.decimalDigits).count == 0 && !self.k_isHasChinese
    }
    
    /// 密码是否符合规则 6-16位字母或数组
    public var k_isPassword: Bool {
        return self.k_isCorrect("^[^\\u4E00-\\u9FA5\\uF900-\\uFA2D\\u0020]{6,16}")
    }
    
    /// 是否符合身份证规则
    public var k_isIdCard: Bool {
        
        return self.k_isCorrect("^(\\d{14}|\\d{17})(\\d|[xX])$")
    }
    
    /// 格式是否正确
    private func k_isCorrect(_ str: String) -> Bool {
        
        return NSPredicate(format: "SELF MATCHES %@", str).evaluate(with: self)
    }
}

extension String {
    
    /// json串转为任意类型
    ///
    /// - Returns: 任意类型
    public func k_jsonStrToObject() -> Any? {
        
        if self.k_isEmpty {
            return nil
        }
        if let data = self.data(using: String.Encoding.utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        }
        return nil
    }
}

extension Collection {
    
    /// 转为Json字符串
    ///
    /// - Returns: json串
    public func k_toJsonStr() -> String? {
        
        if let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) {
            return String.init(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }
}

extension String {
    
    /// 去除空格等 给html传值
    ///
    /// - Returns: 新字符串
    public func k_noWhiteSpaceString() -> String {
        var newStr = self
        newStr = newStr.replacingOccurrences(of: "\r", with: "")
        newStr = newStr.replacingOccurrences(of: "\n", with: "")
        newStr = newStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        newStr = newStr.replacingOccurrences(of: " ", with: "")
        
        return newStr
    }
    
    /// 去除换行符等 给html传值
    ///
    /// - Returns: 新字符串
    public func k_removeEnterString() -> String {
        var newStr = self
        newStr = newStr.replacingOccurrences(of: "\n", with: "<br/>")
        newStr = newStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        return newStr
    }
    
    /// 获取拼音
    ///
    /// - Returns: 拼音
    public func k_toPinYin() -> String{
        let mutableString = NSMutableString(string: self)
        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        //去掉空格
        return String(mutableString).replacingOccurrences(of: " ", with: "")
    }
}

extension String {
    
    /// 计算文字宽度
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - font: 字体
    /// - Returns: 宽度
    public func k_boundingWidth(height: CGFloat, font: UIFont) -> CGFloat {
        
        let label = UILabel()
        label.text = nil
        label.attributedText = nil
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: CGFloat(MAXFLOAT), height: height)
        label.font = font
        label.text = self
        label.sizeToFit()
        
        return label.frame.width
    }
    
    //MARK: 计算文字尺寸
    /// 计算文字尺寸
    ///
    /// - Parameters:
    ///   - size: 包含一个最大的值 CGSize(width: max, height: 20.0)
    ///   - font: 字体大小
    /// - Returns: 尺寸
    public func k_boundingSize(size: CGSize, font: UIFont) -> CGSize {
        
        return NSString(string: self).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    
    /// 计算文字高度
    ///
    /// - Parameters:
    ///   - textView: 输入区域
    ///   - width: 宽度
    /// - Returns: 高度
    public func k_boundingHeight(with textView: UITextView, width: CGFloat) -> CGFloat {
        return textView.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT))).height
    }
}

extension String {
    
    /// range -> NSRange
    ///
    /// - Parameter range: range
    /// - Returns: NSRange
    public func k_toNSRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
}

extension String {
    
    /// 文字转图片
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - textColor: 文字颜色
    /// - Returns: 图片
    public func k_toTextImage(font: UIFont, textColor: UIColor) -> UIImage? {
        
        let imgHeight: CGFloat = 16.0
        let imgWidth = self.k_boundingSize(size: CGSize(width: UIScreen.main.bounds.width, height: imgHeight), font: font).width
        
        let attributeStr = NSAttributedString.init(string: self, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: textColor])
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imgWidth, height: imgHeight), false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setCharacterSpacing(10.0)
        context?.setTextDrawingMode(CGTextDrawingMode.fill)
        context?.setFillColor(UIColor.white.cgColor)
        
        attributeStr.draw(in: CGRect(x: 0.0, y: 0.0, width: imgWidth, height: imgHeight))
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg
    }
}

extension String {
    
    /// 生成二维码
    ///
    /// - Parameters:
    ///   - centerImg: 中间的小图
    ///   - block: 回调
    public func k_createQRCode(centerImg: UIImage?, block: ((UIImage?)->Void)?) {
        
        if self.k_isEmpty {
            DispatchQueue.main.async {
                block?(nil)
            }
            return
        }
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(self.data(using: String.Encoding.utf8, allowLossyConversion: true), forKey: "inputMessage")
        if let image = filter?.outputImage {
            let size: CGFloat = 300.0
            
            let integral: CGRect = image.extent.integral
            let proportion: CGFloat = min(size/integral.width, size/integral.height)
            
            let width = integral.width * proportion
            let height = integral.height * proportion
            let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
            let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
            
            let context = CIContext(options: nil)
            if let bitmapImage: CGImage = context.createCGImage(image, from: integral) {
                bitmapRef.interpolationQuality = CGInterpolationQuality.none
                bitmapRef.scaleBy(x: proportion, y: proportion);
                bitmapRef.draw(bitmapImage, in: integral);
                if let image: CGImage = bitmapRef.makeImage() {
                    var qrCodeImage = UIImage(cgImage: image)
                    if let centerImg = centerImg {
                        // 图片拼接
                        UIGraphicsBeginImageContextWithOptions(qrCodeImage.size, false, UIScreen.main.scale)
                        qrCodeImage.draw(in: CGRect(x: 0.0, y: 0.0, width: qrCodeImage.size.width, height: qrCodeImage.size.height))
                        centerImg.draw(in: CGRect(x: (qrCodeImage.size.width - 35.0) / 2.0, y: (qrCodeImage.size.height - 35.0) / 2.0, width: 35.0, height: 35.0))
                        
                        qrCodeImage = UIGraphicsGetImageFromCurrentImageContext() ?? qrCodeImage
                        UIGraphicsEndImageContext()
                        DispatchQueue.main.async {
                            block?(qrCodeImage)
                        }
                    }
                    DispatchQueue.main.async {
                        block?(qrCodeImage)
                    }
                }
                DispatchQueue.main.async {
                    block?(nil)
                }
            }
            DispatchQueue.main.async {
                block?(nil)
            }
        }
        DispatchQueue.main.async {
            block?(nil)
        }
    }
    
    //MARK: - 生成高清的UIImage
    private func setUpHighDefinitionImage(_ image: CIImage, size: CGFloat) -> UIImage? {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        if let image: CGImage = bitmapRef.makeImage() {
            return UIImage(cgImage: image)
        }
        return nil
    }
}
