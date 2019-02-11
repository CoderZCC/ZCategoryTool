//
//  UIView+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIView {
    
    /// x
    var k_x: CGFloat {
        set {
            
            var newFrame = self.frame
            newFrame.origin.x = newValue
            self.frame = newFrame
        }
        get { return self.frame.origin.x }
    }
    /// y
    var k_y: CGFloat {
        set {
            
            var newFrame = self.frame
            newFrame.origin.y = newValue
            self.frame = newFrame
        }
        get { return self.frame.origin.y }
    }
    /// width
    var k_width: CGFloat {
        set {
            
            var newFrame = self.frame
            newFrame.size.width = newValue
            self.frame = newFrame
        }
        get { return self.frame.size.width }
    }
    /// height
    var k_height: CGFloat {
        set {
            
            var newFrame = self.frame
            newFrame.size.height = newValue
            self.frame = newFrame
        }
        get { return self.frame.size.height }
    }
    /// size
    var k_size: CGSize {
        set {
            
            var newFrame = self.frame
            newFrame.size = newValue
            self.frame = newFrame
        }
        get { return self.frame.size }
    }
    
    /// center
    var k_center: CGPoint {
        set {
            
            var newCenter = self.center
            newCenter = newValue
            self.center = newCenter
        }
        get { return self.center }
    }
    /// 中心点x
    var k_centerX: CGFloat {
        set {
            
            var newCenter = self.center
            newCenter.x = newValue
            self.center = newCenter
        }
        get { return self.center.x }
    }
    /// 中心点y
    var k_centerY: CGFloat {
        set {
            
            var newCenter = self.center
            newCenter.y = newValue
            self.center = newCenter
        }
        get {
            return self.center.y
        }
    }
}

var k_UIViewClickActionKey: Int = 0

extension UIView {
    
    //MARK: 设置为圆形控件
    /// 设置为圆形控件
    func k_setCircleImgV() {
        
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = frame.height / 2.0
        self.clipsToBounds = true
    }
    
    //MARK: 设置圆角
    /// 设置圆角
    ///
    /// - Parameter radius: 圆角数
    func k_setCornerRadius(_ radius: CGFloat) {
        
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    //MARK: 设置边框
    /// 设置边框
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - width: 宽度
    func k_setBorder(color: UIColor, width: CGFloat) {
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    //MARK: 设置特定的圆角
    /// 设置特定的圆角
    ///
    /// - Parameters:
    ///   - corners: 位置
    ///   - radii: 圆角
    func k_setCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        
        let maskPath = UIBezierPath(roundedRect: CGRect.init(x: 0.0, y: 0.0, width: self.bounds.width, height: self.bounds.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: self.bounds.height)
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    //MARK: UIView添加点击事件
    /// UIView添加点击事件
    ///
    /// - Parameters:
    ///   - target: 目标
    ///   - action: 事件
    func k_addTarget(action: Selector) {
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: action)
        self.addGestureRecognizer(tap)
    }

    /// UIView添加点击事件
    ///
    /// - Parameter clickAction: 点击回调
    func k_addTarget(_ clickAction: ((UIGestureRecognizer)->Void)?) {
        
        objc_setAssociatedObject(self, &k_UIViewClickActionKey, clickAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(k_tapAction))
        self.addGestureRecognizer(tap)
    }
    
    /// UIView添加长按事件
    ///
    /// - Parameter clickAction: 点击回调
    func k_addLongPressTarget(_ clickAction: ((UIGestureRecognizer)->Void)?) {
        
        objc_setAssociatedObject(self, &k_UIViewClickActionKey, clickAction, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        self.isUserInteractionEnabled = true
        let tap = UILongPressGestureRecognizer.init(target: self, action: #selector(k_tapAction))
        tap.minimumPressDuration = 0.5
        self.addGestureRecognizer(tap)
    }
    
    /// UIView点击事件
    @objc func k_tapAction(tap: UIGestureRecognizer) {
        
        DispatchQueue.main.async {
            (objc_getAssociatedObject(self, &k_UIViewClickActionKey) as! ((UIGestureRecognizer)->Void)?)?(tap)
        }
    }
    
    //MARK: 单击移除键盘
    /// 单击移除键盘
    func k_tapDismissKeyboard() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDismissAction))
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) { [weak self] (note) in
            
            self?.addGestureRecognizer(tap)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: OperationQueue.main) { [weak self] (note) in
            
            self?.removeGestureRecognizer(tap)
        }
    }
    @objc private func tapDismissAction() {
        
        self.endEditing(true)
    }
}

extension UIView {
    
    /// 抖动动画
    func startPeekAnimation() {
        
        self.layer.removeAllAnimations()
        // 抖动动画
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.duration = 0.5
        animation.calculationMode = CAAnimationCalculationMode.cubic
        animation.values = [1.5, 0.8, 1.0, 1.2, 1.0]
        self.layer.add(animation, forKey: "transform.scale")
    }
}
