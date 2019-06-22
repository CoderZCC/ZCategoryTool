//
//  UITextView+Ext.swift
//  ZCategoryToolDemo
//
//  Created by ZCC on 2019/2/26.
//  Copyright © 2019 zcc. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// 占位文字
    public var k_placeholder: String? {
        set {
            k_setAssociatedObject(key: "kUITextViewPlaceholderKey", value: newValue)
            self._createPlaceholderView()
            self._placeholderView?.text = newValue
        }
        get {
            return k_getAssociatedObject(key: "kUITextViewPlaceholderKey") as? String
        }
    }
    
    /// 占位文字颜色
    public var k_placeholderColor: UIColor? {
        set {
            
            k_setAssociatedObject(key: "kUITextViewPlaceholderColorKey", value: newValue)
            self._createPlaceholderView()
        }
        get {
            return k_getAssociatedObject(key: "kUITextViewPlaceholderColorKey") as? UIColor
        }
    }
    /// 最大文字长度
    public var k_limitTextLength: Int? {
        set {
            k_setAssociatedObject(key: "kUITextViewLimitTextLengthKey", value: newValue)
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(_textChangeNoteAction), name: UITextView.textDidChangeNotification, object: nil)
        }
        get {
            return k_getAssociatedObject(key: "kUITextViewLimitTextLengthKey") as? Int
        }
    }
    /// 占位工具, 可以在这里修改富文本属性
    public var _placeholderView: UITextView? {
        set {
            k_setAssociatedObject(key: "kUITextViewPlaceholderViewKey", value: newValue)
        }
        get {
            return k_getAssociatedObject(key: "kUITextViewPlaceholderViewKey") as? UITextView
        }
    }
        
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // 赋值
        self._placeholderView?.frame = CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: 100.0)
        self._placeholderView?.textColor = self.k_placeholderColor
        // 字体
        self._placeholderView?.font = self.font
        self._placeholderView?.backgroundColor = self.backgroundColor
        self._placeholderView?.typingAttributes = self.typingAttributes
        self._placeholderView?.textContainerInset = self.textContainerInset
    }
    
    // 重写方法
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil {
            // 移除通知
            NotificationCenter.default.removeObserver(self)
            self._placeholderView?.removeFromSuperview()
            self._placeholderView = nil
        }
    }
    
    /// 创建占位工具试图
    private func _createPlaceholderView() {
        if self._placeholderView != nil { return }
        
        let textView = UITextView.init()
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.setContentOffset(CGPoint.zero, animated: false)
        textView.backgroundColor = self.backgroundColor
        textView.font = self.font
        
        self.insertSubview(textView, at: 0)
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(_textChangeNoteAction), name: UITextView.textDidChangeNotification, object: nil)
        self._placeholderView = textView
    }
 
    /// 文字变化事件
    ///
    /// - Parameter note: 通知
    @objc private func _textChangeNoteAction(note: NSNotification) {
        guard let currentTv = note.object as? UITextView else { return }
        if currentTv != self { return }
        let inputText: String = currentTv.text ?? ""
        self._placeholderView?.isHidden = !inputText.isEmpty
        if let maxCount = self.k_limitTextLength, maxCount > 0 {
            if inputText.count > maxCount && currentTv.markedTextRange == nil {
                // 字数
                currentTv.text = inputText.k_subText(to: maxCount - 1)
            }
        }
    }
}

extension UITextView {
    
    /// 计算文字高度
    ///
    /// - Parameters:
    ///   - textView: 输入区域
    ///   - width: 宽度
    /// - Returns: 高度
    public func k_boundingHeight(width: CGFloat) -> CGFloat {
        let size = self.sizeThatFits(CGSize(width: width, height: CGFloat(Int.max)))
        
        return size.height
    }
}
