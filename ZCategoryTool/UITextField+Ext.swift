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
            guard let maxCount = newValue else { return }
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] (note) in
                
                let inputText: String = self?.text ?? ""
                if inputText.count > maxCount && self?.markedTextRange == nil {
                    self?.text = inputText.k_subText(to: maxCount - 1)
                }
            }
        }
        get { return nil }
    }
    
    /// 最大字节长度 中文占两个字节 英文占一个 限制的是中文(15就是15个汉字,30个字母)
    public var k_limitByteLength: Int? {
        set {
            guard let maxCount = newValue else { return }
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] (note) in
                
                let inputText: String = self?.text ?? ""
                let inputCount = inputText.byteCount
                if inputCount > maxCount && self?.markedTextRange == nil {
                    self?.text = inputText.k_subTextByByte(to: maxCount)
                }
            }
        }
        get { return nil }
    }
}
