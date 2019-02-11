//
//  UIIImageView+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/16.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 设置内容模式
    ///
    /// - Parameters:
    ///   - model: 模式
    ///   - clips: 是否裁剪
    public func k_contenModel(model: UIView.ContentMode = .scaleAspectFill, clips: Bool = true) {
        
        self.contentMode = model
        self.clipsToBounds = clips
    }
}

extension UIImageView {
    
    /// 开始加载
    public func k_startLoading(duration: Double = 0.6) {
        
        DispatchQueue.main.async {
        
            if self.isHidden {
                
                // 先移除
                self.layer.removeAnimation(forKey: "rotationAnimation")
                // 开始加载
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
                rotationAnimation.duration = duration
                // 旋转累加角度
                rotationAnimation.isCumulative = true
                rotationAnimation.repeatCount = Float(Int.max)
                self.layer.add(rotationAnimation, forKey: "rotationAnimation")
                
                self.isHidden = false
            }
        }
    }
    
    /// 结束加载
    public func k_stopLoading() {
        
        DispatchQueue.main.async {
            
            if !self.isHidden {
                
                self.layer.removeAnimation(forKey: "rotationAnimation")
                self.isHidden = true
            }
        }
    }
}
