//
//  UIButton+Ext.swift
//  OrderManager
//
//  Created by ZCC on 2018/7/12.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIButton {
    
    //MARK: UIButton添加点击事件
    /// UIButton添加点击事件
    ///
    /// - Parameters:
    ///   - events: 事件
    ///   - block: 回调
    public func k_addTarget(events: UIControl.Event = .touchUpInside, block: @escaping()->Void) {
        
        k_setAssociatedObject(key: "kUIButtonClickKey", value: block)
        self.addTarget(self, action: #selector(k_btnAction), for: events)
    }
    @objc private func k_btnAction() {
        
        if let block = k_getAssociatedObject(key: "kUIButtonClickKey") as? ()->Void {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
    //MARK: 设置特殊的按钮
    /// 设置特殊的按钮
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - title: 文字
    ///   - titlePosition: 文字位置
    ///   - spacing: 文字和图片间隔
    ///   - state: 按钮状态
    public func k_setBtn(image: UIImage?, title: String, titlePosition: UIView.ContentMode, spacing: CGFloat = 5.0, state: UIControl.State = .normal) {
        
        self.imageView?.contentMode = .center
        self.setImage(image, for: state)
        
        self.positionLabelRespectToImage(title: title, position: titlePosition, spacing: spacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    fileprivate func positionLabelRespectToImage(title: String, position: UIView.ContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font ?? UIFont.systemFont(ofSize: 14.0)
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        var titleInsets: UIEdgeInsets!
        var imageInsets: UIEdgeInsets!
        
        switch (position){
        case .top:
            
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            
        case .bottom:
            
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            
        case .left:
            
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
            
        case .right:
            
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        default:
            
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}

/// 延迟调用,防止多次调用
extension UIControl {
    
    /// 延迟时间
    public var k_delayDuration: Double? {
        set {
            k_setAssociatedObject(key: "kUIButtonDelayDurationKey", value: newValue)
        }
        get { return k_getAssociatedObject(key: "kUIButtonDelayDurationKey") as? Double }
    }
    
    /// 替换点击方法
    public class func replaceClickActionMethod() {
        
        DispatchQueue.k_once("UIControl_replaceClickActionMethod") {
            let originalMethod = class_getInstanceMethod(UIButton.self, #selector(UIControl.sendAction(_:to:for:)))
            let changedmethod = class_getInstanceMethod(UIButton.self, #selector(UIControl.mySendAction(_:to:for:)))
            
            if let originalMethod = originalMethod, let changedmethod = changedmethod {
                method_exchangeImplementations(originalMethod, changedmethod)
            }
        }
    }

    /// 按钮是否可用
    private var isBtnActionEnabled: Bool {
        set {
            k_setAssociatedObject(key: "kUIButtonDelayKey", value: newValue)
        }
        get { return (k_getAssociatedObject(key: "kUIButtonDelayKey") as? Bool) ?? true }
    }
    
    /// 发送事件
    @objc func mySendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
        if let duration = self.k_delayDuration {
            if self.isBtnActionEnabled {
                self.isBtnActionEnabled = false
                mySendAction(action, to: target, for: event)
                DispatchQueue.k_asyncAfterOnMain(dealyTime: duration) { [weak self] in
                    self?.isBtnActionEnabled = true
                }
            }
        } else {
            mySendAction(action, to: target, for: event)
        }
    }
}

extension UIControl {
    
    /// 添加点击事件
    public func addTarget(events: UIControl.Event, inTarget: UIResponder, block: ((UIControl, UIResponder)->Void)?) {
        
        var dict: [UInt: UIControlWrapper] = (k_getAssociatedObject(key: "UIControlAction") as? [UInt: UIControlWrapper]) ?? [:]
        let wrapper = UIControlWrapper(target: inTarget, sender: self, block: block)
        dict[events.rawValue] = wrapper
        k_setAssociatedObject(key: "UIControlAction", value: dict)
        self.addTarget(wrapper, action: #selector(wrapper._eventsAction), for: events)
    }
    
    /// 移除某一个/全部点击事件
    public func removeTarget(events: UIControl.Event? = nil) {
        
        var dict = k_getAssociatedObject(key: "UIControlAction") as? [UInt: UIControlWrapper]
        if let events = events {
            dict?.removeValue(forKey: events.rawValue)
        } else {
            dict?.removeAll()
            dict = nil
        }
        k_setAssociatedObject(key: "UIControlAction", value: dict)
    }
    
    /// 响应事件
    class UIControlWrapper {
        weak var _target: UIResponder!
        weak var _sender: UIControl!
        var _block: ((UIControl, UIResponder)->Void)?
        init(target: UIResponder, sender: UIControl, block: ((UIControl, UIResponder)->Void)?) {
            self._target = target
            self._sender = sender
            self._block = block
        }
        @objc func _eventsAction(sender: UIControl) {
            DispatchQueue.main.async {
                self._block?(self._sender, self._target)
            }
        }
        deinit {
            self._target = nil
            self._sender = nil
            self._block = nil
        }
    }
}
