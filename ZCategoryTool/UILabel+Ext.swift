//
//  UILabel+Ext.swift
//  ZCategoryToolDemo
//
//  Created by ZCC on 2019/2/20.
//  Copyright © 2019 zcc. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 设置行高
    ///
    /// - Parameters:
    ///   - lineHeight: 行高
    ///   - self.lineBreakMode = .byTruncatingTail 变...在最后加这个
    ///   - text: 文字
    public func k_setLineHeight(lineHeight: CGFloat, text: String?) {
        guard let text = text else {
            self.text = nil
            self.attributedText = nil
            return
        }
        let realyFont: UIFont = self.font ?? UIFont.systemFont(ofSize: 14.0)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        let baseLineOffset = (lineHeight - realyFont.lineHeight) / 4.0
        self.attributedText = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle, .baselineOffset: baseLineOffset, .font: realyFont, .foregroundColor: self.textColor ?? UIColor.black])
    }
}

extension String {
    
    /// 计算文字高度
    ///
    /// - Parameters:
    ///   - maxWidth: 最大宽度
    ///   - lineHeight: 行高
    ///   - font: 字体大小
    /// - Returns: 高度
    public func k_boundTextHeight(maxWidth: CGFloat, lineHeight: CGFloat, font: UIFont?) -> CGFloat {
        if self.k_isEmpty {
            return font?.lineHeight ?? 0.0
        }
        let realyFont: UIFont = font ?? UIFont.systemFont(ofSize: 14.0)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        let baseLineOffset = (lineHeight - realyFont.lineHeight) / 4.0
        return NSString.init(string: self).boundingRect(with: CGSize(width: maxWidth, height: CGFloat(Int.max)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle, .baselineOffset: baseLineOffset, .font: realyFont], context: nil).size.height
    }
}
