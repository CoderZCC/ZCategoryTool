//
//  String+Ext.swift
//  ExtensionTool
//
//  Created by ZCC on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

//MARK: 字符串相关
public extension String {
    
    /// 字符串格式化所有参数 [key: value]
    var k_paramaters: [String: String] {
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
    func k_toMD5Str() -> String {
        
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
    var securePhoneStr: String {
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
    var byteCount: Int {
        let encoding = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        
        return self.lengthOfBytes(using: String.Encoding(rawValue: encoding))
    }
    
    /// 转为URL
    ///
    /// - Returns: URL
    func k_toURL() -> URL? {
        
        return URL(string: self)
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
    func k_toDate(formatter: String) -> Date {
        let fat = DateFormatter()
        fat.dateFormat = formatter
        var date = fat.date(from: self) ?? Date()
        // 时区处理
        let timeZone = NSTimeZone.system.secondsFromGMT(for: date)
        date.addTimeInterval(TimeInterval(timeZone))
        return date
    }
    
    //MARK: 时间戳转为字符串
    /// 时间戳转为字符串
    ///
    /// - Parameters:
    ///   - timeStamp: 时间戳 10位/13位
    ///   - output: 输出格式 默认:yyyy年MM月dd日 HH:mm:ss
    /// - Returns: 日期字符串
    static func k_timeStampToDateString(_ timeStamp: String, output: String = "yyyy年MM月dd日 HH:mm:ss") -> String {
        let newTimeStamp = timeStamp.count > 10 ? (timeStamp.k_subText(to: 9)): (timeStamp)
        let str = NSString(string: newTimeStamp)
        let doubleValue = str.doubleValue
        
        let fat = DateFormatter()
        fat.dateFormat = output
        
        return fat.string(from: Date(timeIntervalSince1970: doubleValue))
    }
    
    //MARK: 比较两个格式相同的时间大小
    /// 比较两个格式相同的时间大小
    ///
    /// - Parameter otherTime: 时间
    /// - Returns: 结果 0: 相等; 1: otherTime大; 2: otherTime小
    func k_compareToStr(_ otherTime: String, formatter: String) -> Int {
        let resultDic: [ComparisonResult: Int] = [.orderedSame: 0, .orderedAscending: 1, .orderedDescending: 2]
        let t1 = self.k_toDate(formatter: formatter)
        let t2 = otherTime.k_toDate(formatter: formatter)
        
        return resultDic[t1.compare(t2)]!
    }
    
    //MARK: caches路径
    /// caches路径
    static var k_cachesPath: String {
        
        return NSHomeDirectory() + "/Library/Caches/"
    }
    
    //MARK: documents路径
    /// documents路径
    static var k_documentsPath: String {
        
        return NSHomeDirectory() + "/Documents/"
    }
    
    //MARK: tmp路径
    /// tmp路径
    static var k_tmpPath: String {
        
        return NSHomeDirectory() + "/tmp/"
    }
    
    //MARK: 转为Int
    /// 转为Int
    ///
    /// - Returns: Int
    func k_toInt() -> Int? {
        
        return Int(self)
    }
    
    //MARK: 转为转为CGFloat
    /// 转为CGFloat
    ///
    /// - Returns: CGFloat
    func k_toCGFloat() -> CGFloat {
        
        return CGFloat(Double(self) ?? 0.0)
    }
    
    /// 获取Nib文件路径
    var nibPath: String? {
        return Bundle.main.path(forResource: self, ofType: "nib")
    }
    /// 创建Nib文件
    var nib: UINib? {
        return UINib.init(nibName: self, bundle: nil)
    }
}

// MAR: -字符串处理
public extension String {
    
    /// 去除首尾空格
    ///
    /// - Returns: 字符串
    func k_removeHeadAndFoot() -> String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    /// 去除左右的空格和换行符
    ///
    /// - Returns: 结果字符串
    func k_trimmingStr() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 插入字符串
    ///
    /// - Parameters:
    ///   - text: 要插入的字符串
    ///   - index: 要插入的位置
    /// - Returns: 结果字符串
    @discardableResult
    mutating func k_insert(_ text: String, at index: Int) -> String {
        if index > count - 1 || index < 0 {
            return self
        }
        let insertIndex = self.index(startIndex, offsetBy: index)
        insert(contentsOf: text, at: insertIndex)
        return self
    }
    
    /// 插入字符
    ///
    /// - Parameters:
    ///   - text: 要插入的字符
    ///   - index: 要插入的位置
    /// - Returns: 结果字符串
    @discardableResult
    mutating func k_insert(_ text: Character, at index: Int) -> String {
        if index > count - 1 || index < 0 {
            return self
        }
        let insertIndex = self.index(startIndex, offsetBy: index)
        insert(text, at: insertIndex)
        return self
    }
    
    /// 删除字符串
    ///
    /// - Parameter text: 要删除的字符串
    /// - Returns: 结果字符串
    @discardableResult
    mutating func k_remove(_ text: String) -> String {
        if let removeIndex = range(of: text) {
            removeSubrange(removeIndex)
        }
        return self
    }
    
    /// 删除字符串
    ///
    /// - Parameters:
    ///   - index: 删除的字符串起始位置
    ///   - length: 删除的字符串长度
    /// - Returns: 结果字符串
    @discardableResult
    mutating func k_remove(at index: Int, length: Int) -> String {
        if index > count - 1 || index < 0 || length < 0 || index + length > count {
            return self
        }
        let start = self.index(startIndex, offsetBy: index)
        let end = self.index(start, offsetBy: length)
        removeSubrange(start ..< end)
        return self
    }
    
    /// 删除字符
    ///
    /// - Parameter index: 要删除的位置
    /// - Returns: 结果字符串
    @discardableResult
    mutating func k_remove(at index: Int) -> String {
        if index > count - 1 || index < 0 {
            return self
        }
        let removeIndex = self.index(startIndex, offsetBy: index)
        remove(at: removeIndex)
        return self
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
    func k_subText(from: Int = 0, to: Int) -> String {
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
    func k_replaceStr(range: NSRange, replaceStr: String) -> String {
        var newStr: String = self
        if let range = Range.init(range, in: self) {
            
            newStr.replaceSubrange(range, with: replaceStr)
            
        } else {
            
            debugPrint("范围不正确")
        }
        return newStr
    }

}

// MARK: -常规判断
public extension String {
    
    /// 是否包含Emoij
    ///
    /// - Returns: 是/否
    func k_containsEmoij() -> Bool {
        
        return self.k_isRegularCorrect("[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")
    }
    
    /// 移除字符串中的Emoij
    ///
    /// - Returns: 新字符串
    func k_deleteEmoij() -> String {
        
        return self.k_removeMatchRegular(expression: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", with: "")
    }
    
    /// 是否为空, 全空格/empty
    ///
    /// - Returns: 是否
    var k_isEmpty: Bool {
        if self.isEmpty {
            return true
        }
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
    
    /// 是否是数字
    var k_isNumber: Bool {
        return self.k_isRegularCorrect("^[0-9]+$")
    }
    
    /// 是否是字母
    var k_isLetter: Bool {
        return self.k_isRegularCorrect("^[A-Za-z]+$")
    }
    
    /// 是否符合邮箱规则
    var k_isEmail: Bool {
        return self.k_isRegularCorrect("^([A-Za-z0-9_\\-\\.\\u4e00-\\u9fa5])+\\@([A-Za-z0-9_\\-\\.\\u4e00-\\u9fa5])+\\.([A-Za-z\\u4e00-\\u9fa5]+)$")
    }
    
    /// 是否包含汉字
    var k_isHasChinese: Bool {
        for chara in self {
            if chara >= "\u{4E00}" && chara <= "\u{9FA5}" {
                return true
            }
        }
        return false
    }
    
    /// 是否符合手机号码规则
    var k_isPhoneNum: Bool {
        
        // 全是数字, 不是空格
        return !self.k_isEmpty && self.trimmingCharacters(in: CharacterSet.decimalDigits).count == 0 && !self.k_isHasChinese
    }
    
    /// 密码是否符合规则 6-16位字母或数组
    var k_isPassword: Bool {
        return self.k_isRegularCorrect("^[^\\u4E00-\\u9FA5\\uF900-\\uFA2D\\u0020]{6,16}")
    }
    
    /// 是否符合身份证规则
    var k_isIdCard: Bool {
        
        return self.k_isRegularCorrect("^(\\d{14}|\\d{17})(\\d|[xX])$")
    }
    
    /// 正则是否匹配-谓词方式
    ///
    /// - Parameter str: str
    /// - Returns: 是否
    func k_isRegularCorrect(_ str: String) -> Bool {
        
        return NSPredicate(format: "SELF MATCHES %@", str).evaluate(with: self)
    }
}

// MARK: -正则表达式
public extension String {
    
    /// 是否符合正则表达式
    ///
    /// - Parameter expression: 正则表达式
    /// - Returns: 结果
    func k_isMatchRegular(expression: String) -> Bool {
        if let regularExpression = try? NSRegularExpression.init(pattern: expression, options: NSRegularExpression.Options.caseInsensitive) {
            return regularExpression.matches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: self.count)).count > 0
        }
        return false
    }
    
    /// 是否包含符合正则表达式的字符串
    ///
    /// - Parameter expression: 正则表达式
    /// - Returns: 结果
    func k_isContainRegular(expression: String) -> Bool {
        if let regularExpression = try? NSRegularExpression.init(pattern: expression, options: NSRegularExpression.Options.caseInsensitive) {
            return regularExpression.rangeOfFirstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: self.count)).location != NSNotFound
        }
        return false
    }
    
    /// 替换符合正则表达式的文字
    ///
    /// - Parameters:
    ///   - expression: 正则表达式
    ///   - newStr: 替换后的文字
    /// - Returns: 新字符串
    func k_removeMatchRegular(expression: String, with newStr: String) -> String {
        if let regularExpression = try? NSRegularExpression.init(pattern: expression, options: NSRegularExpression.Options.caseInsensitive) {
            return regularExpression.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: self.count), withTemplate: newStr)
        }
        return self
    }
    
    /// 获取所有符合正则表达式的文字位置
    ///
    /// - Parameter expression: 正则表达式 eg: "@[\\u4e00-\\u9fa5\\w\\-\\_]+ "="@ZCC "
    /// - Returns: [位置]?
    func k_matchRegularRange(expression: String) -> [NSRange]? {
        if let regularExpression = try? NSRegularExpression.init(pattern: expression, options: NSRegularExpression.Options.caseInsensitive) {
            return regularExpression.matches(in: self, options: .reportProgress, range: NSRange(location: 0, length: self.count)).map({ (result) -> NSRange in
                return result.range
            })
        }
        return nil
    }
}

// MARK: -Json串转对象
public extension String {
    
    /// json串转为任意类型
    ///
    /// - Returns: 任意类型
    func k_jsonStrToObject() -> Any? {
        
        if self.k_isEmpty {
            return nil
        }
        if let data = self.data(using: String.Encoding.utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        }
        return nil
    }
}

// MARK: -对象转Json串
public extension Collection {
    
    /// 转为Json字符串
    ///
    /// - Returns: json串
    func k_toJsonStr() -> String? {
        
        if let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) {
            return String.init(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }
}

// MARK: -剔除特殊字符
public extension String {
    
    /// 去除空格等 给html传值
    ///
    /// - Returns: 新字符串
    func k_noWhiteSpaceString() -> String {
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
    func k_removeEnterString() -> String {
        var newStr = self
        newStr = newStr.replacingOccurrences(of: "\n", with: "<br/>")
        newStr = newStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        return newStr
    }
    
    /// 获取拼音
    ///
    /// - Returns: 拼音
    func k_toPinYin() -> String{
        let mutableString = NSMutableString(string: self)
        //把汉字转为拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        //去掉拼音的音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        //去掉空格
        return String(mutableString).replacingOccurrences(of: " ", with: "")
    }
}

// MARK: -文字尺寸相关
public extension String {
    
    /// 计算文字宽度
    ///
    /// - Parameters:
    ///   - height: 高度
    ///   - font: 字体
    /// - Returns: 宽度
    func k_boundingWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel()
        label.frame = CGRect(x: 0.0, y: 0.0, width: CGFloat(Int.max), height: height)
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
    func k_boundingSize(size: CGSize, font: UIFont) -> CGSize {
        return NSString(string: self).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
}

// MARK: -Range->NSRange
public extension String {
    
    /// range -> NSRange
    ///
    /// - Parameter range: range
    /// - Returns: NSRange
    func k_toNSRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
}

// MARK: -文字转图片
public extension String {
    
    /// 文字转图片
    ///
    /// - Parameters:
    ///   - font: 字体大小
    ///   - textColor: 文字颜色
    /// - Returns: 图片
    func k_toTextImage(font: UIFont, textColor: UIColor) -> UIImage? {
        
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

// MARK: -二维码相关
public extension String {
    
    /// 生成二维码
    ///
    /// - Parameters:
    ///   - centerImg: 中间的小图
    ///   - block: 回调
    func k_createQRCode(centerImg: UIImage? = nil) -> UIImage? {
        
        if self.k_isEmpty {
            return nil
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
                        return qrCodeImage
                    } else {
                        return qrCodeImage
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
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

// MARK: -编解码
public extension String {
    
    /// 编码之后的url
    var k_urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// 解码之后的url
    var k_urlDecoded: String? {
        return removingPercentEncoding
    }
    
    /// base64编码之后的字符串
    var k_base64Encoded: String? {
        guard let base64Data = data(using: .utf8) else { return nil }
        return base64Data.base64EncodedString()
    }
    
    /// base64解码之后的字符串
    var k_base64Decoded: String? {
        guard let base64Data = Data(base64Encoded: self) else { return nil }
        return String(data: base64Data, encoding: .utf8)
    }
    
}

// MARK: -数据转模型
public extension String {
    
    /*
    // 使用方法
    class TestModel: Decodable {
        let text: String?
    }
    "{\"text\": \"zcc\"}".k_convertToModel(modelType: TestModel.self)
    */
    /// Json转Model模型工具
    /// 数据模型的属性必须跟接口返回的数据类型相匹配!!!
    /// - Parameter modelType: T.Type
    /// - Returns: 数据模型
    func k_convertToModel <T: Decodable>(modelType: T.Type) -> T? {
        guard let jsonData = self.data(using: String.Encoding.utf8) else { return nil }
        
        return try? JSONDecoder().decode(modelType, from: jsonData)
    }
}

// MARK: -数据转模型
public extension Data {
    
    /// JsonData转Model模型工具
    /// 数据模型的属性必须跟接口返回的数据类型相匹配!!!
    ///
    /// - Parameter modelType: NSObject.self
    /// - Returns: 数据模型
    func k_convertToModel <T: Decodable>(modelType: T.Type) -> T? {
        return try? JSONDecoder().decode(modelType, from: self)
    }
}
