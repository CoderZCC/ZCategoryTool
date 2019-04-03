//
//  UITextView+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UITextField {
    
    /// 占位文字颜色
    public var k_placeholderColor: UIColor? {
        set {
            self.setValue(newValue, forKeyPath: "_placeholderLabel.textColor")
        }
        get { return nil }
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
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil {
            // 移除通知
            NotificationCenter.default.removeObserver(self)
        }
    }
}
