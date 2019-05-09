//
//  UIScrollView+Ext.swift
//  ZCategoryToolDemo
//
//  Created by ZCC on 2019/2/14.
//  Copyright © 2019 zcc. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let tapView = super.hitTest(point, with: event)
        if let tapView = tapView {
            
            self.isScrollEnabled = !(tapView.isKind(of: UISlider.self))
        }
        return tapView
    }
}

extension UIScrollView {
    
    /// 原始大小
    private var _originalFrame: CGRect? {
        set {
            k_setAssociatedObject(key: "_kUIScrollViewFrameKey", value: newValue)
        }
        get {
            return k_getAssociatedObject(key: "_kUIScrollViewFrameKey") as? CGRect
        }
    }
    
    /// 根据scrollView截图
    ///
    /// - Parameters:
    ///   - reallySize: 真是大小,默认是contentSize
    ///   - block: 图片
    public func k_snpshotImage(reallySize: CGSize? = nil, block: ((UIImage?)->Void)?) {
        
        if Thread.isMainThread {
            let clipSize: CGSize = reallySize ?? self.contentSize
            UIGraphicsBeginImageContextWithOptions(clipSize, false, UIScreen.main.scale)
            if let context = UIGraphicsGetCurrentContext() {
                self._originalFrame = self.frame
                // 重设大小
                var newFrame = self.frame
                newFrame.size.width = clipSize.width
                newFrame.size.height = clipSize.height
                self.frame = newFrame
                self.contentOffset = CGPoint.zero
                self.contentInset = UIEdgeInsets.zero
                self.alpha = 1.0
                self.isHidden = false
                self.transform = CGAffineTransform.identity
                
                self.layer.render(in: context)
                let img = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                // 恢复大小
                if let originalFrame = self._originalFrame {
                    self.frame = originalFrame
                }
                block?(img)
            } else {
                block?(nil)
            }
        } else {
            
            DispatchQueue.main.async {
                self.k_snpshotImage(reallySize: reallySize, block: block)
            }
        }
    }
    
}
