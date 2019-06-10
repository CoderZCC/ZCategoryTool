//
//  UITextView+Ext.swift
//  ExtensionTool
//
//  Created by ZCC on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UITextField {
    
    /// 占位文字颜色
    public var k_placeholderColor: UIColor? {
        set {
            k_setAssociatedObject(key: "k_placeholderColor", value: newValue)
        }
        get { return k_getAssociatedObject(key: "k_placeholderColor") as? UIColor }
    }
    
    /// 最大文字长度
    public var k_limitTextLength: Int? {
        set {
            k_setAssociatedObject(key: "kUITextFieldLimitTextLengthKey", value: newValue)
            NotificationCenter.default.removeObserver(self)
            if (newValue ?? 0) > 0 {
                NotificationCenter.default.addObserver(self, selector: #selector(_textFieldChangeAction), name: UITextField.textDidChangeNotification, object: nil)
            }
        }
        get {
            return k_getAssociatedObject(key: "kUITextFieldLimitTextLengthKey") as? Int
        }
    }
    
    @objc private func _textFieldChangeAction(note: NSNotification) {
        guard let maxCount = self.k_limitTextLength else { return }
        let inputText: String = self.text ?? ""
        if inputText.count > maxCount && self.markedTextRange == nil {
            self.text = inputText.k_subText(to: maxCount - 1)
        }
    }
    
    // 重写方法
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if let color = self.k_placeholderColor, let placeholder = self.placeholder, self.attributedPlaceholder == nil {
            let defaultFont = self.font ?? UIFont.systemFont(ofSize: 14.0)
            let attributeStr = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color, .font: defaultFont])
            self.attributedPlaceholder = attributeStr
        }
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil {
            // 移除通知
            NotificationCenter.default.removeObserver(self)
        }
    }
}
