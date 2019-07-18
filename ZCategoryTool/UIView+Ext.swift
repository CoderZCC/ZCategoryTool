//
//  UIView+Ext.swift
//  OrderManager
//
//  Created by ZCC on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

public extension UIView {
    
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

public extension UIView {
    
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
        
        self.k_cornerRadius = radius
    }
    
    /// 设置圆角
    var k_cornerRadius: CGFloat! {
        set {
            self.layer.cornerRadius = newValue ?? 0.0
            self.clipsToBounds = true
        }
        get {
            return self.layer.cornerRadius
        }
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
        
        k_setAssociatedObject(key: "k_UIViewClickActionKey", value: clickAction)
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(k_tapAction))
        self.addGestureRecognizer(tap)
    }
    
    /// UIView添加长按事件
    ///
    /// - Parameter clickAction: 点击回调
    func k_addLongPressTarget(_ clickAction: ((UIGestureRecognizer)->Void)?) {
        
        k_setAssociatedObject(key: "k_UIViewClickActionKey", value: clickAction)
        self.isUserInteractionEnabled = true
        let tap = UILongPressGestureRecognizer.init(target: self, action: #selector(k_tapAction))
        tap.minimumPressDuration = 0.5
        self.addGestureRecognizer(tap)
    }
    
    /// UIView点击事件
    @objc private func k_tapAction(tap: UIGestureRecognizer) {
        DispatchQueue.main.async {
            (self.k_getAssociatedObject(key: "k_UIViewClickActionKey") as? ((UIGestureRecognizer)->Void))?(tap)
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

public extension UIView {
    
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

public extension UIView {
    
    /// 弹簧动画
    ///
    /// - Parameters:
    ///   - withDuration: 时长
    ///   - usingSpringWithDamping: 0~1.0 越大月不明显
    ///   - animations: 动画
    ///   - completion: 回调
    static func k_animate(withDuration: TimeInterval, usingSpringWithDamping: CGFloat, animations: (()->Void)?, completion: ((Bool)->Void)? = nil) {
        
        guard let animations = animations else { return }
        UIView.animate(withDuration: withDuration, delay: 0.0, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: 0.0, options: .allowAnimatedContent, animations: animations, completion: completion)
    }
}

// MARK: -截屏当前View,生成图片
public extension UIView {
    
    /// 截屏当前View,生成图片
    func k_snapshotImage() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        self.layer.render(in: context)
        let tempImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tempImage
    }
}

// MARK: -绘制虚线
public extension UIView {
    
    /// 绘制虚线
    ///
    /// - Parameters:
    ///   - lineLength: 线长
    ///   - lineSpacing: 间隔
    ///   - lineColor: 颜色
    func k_drawDashLine(lineLength: Int, lineSpacing: Int, lineColor: UIColor) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        // 只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        //shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        
        shapeLayer.lineWidth = self.frame.size.height
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
}
