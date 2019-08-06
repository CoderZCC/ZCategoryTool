//
//  UIScrollView+Ext.swift
//  ZCategoryToolDemo
//
//  Created by ZCC on 2019/2/14.
//  Copyright © 2019 zcc. All rights reserved.
//

import UIKit

// MARK: -防止手势冲突
extension UIScrollView {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let tapView = super.hitTest(point, with: event)
        if let tapView = tapView {
            
            self.isScrollEnabled = !(tapView.isKind(of: UISlider.self))
        }
        return tapView
    }
}

// MARK: -截屏方法
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

// MARK: -下拉消失动效果,当得到某一个值时,进行回调,执行dismiss或者pop或者其他结束展示效果
extension UIScrollView {
    
    /// 设置手势触发
    func k_setTransitionManger(block: (()->Void)?) {
        // 创建一个View,放在顶部或者底部
        let showView = _TransitionManager(scrollView: self, block: block)
        self.addSubview(showView)
    }
}

enum _TransitionStatusEnum {
    /// 默认, 即将回调, 回调
    case normal, willCallBack, callBack
}
class _TransitionManager: UIView {
    
    /// 初始化
    init(scrollView: UIScrollView, block: (()->Void)?) {
        super.init(frame: CGRect(x: 0.0, y: -_headViewHeight, width: UIScreen.main.bounds.width, height: _headViewHeight))
        self._block = block
        self._scrollView = scrollView
        // 添加监听
        self._scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        self.addSubview(self._leftLine)
        self.addSubview(self._rightLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let centerY: CGFloat = self.frame.height - _lineHeight / 2.0 - self._marginY
        self._leftLine.bounds = CGRect(x: 0.0, y: 0.0, width: _lineWidth, height: _lineHeight)
        self._rightLine.bounds = CGRect(x: 0.0, y: 0.0, width: _lineWidth, height: _lineHeight)
        self._leftLine.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        self._rightLine.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        self._leftLine.center = CGPoint(x: (self.frame.width + _lineHeight) / 2.0, y: centerY)
        self._rightLine.center = CGPoint(x: (self.frame.width - _lineHeight) / 2.0, y: centerY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 滚动试图
    private weak var _scrollView: UIScrollView!
    /// 回调
    private var _block: (()->Void)?
    /// 计算角度
    private let _transitionMinNum: CGFloat = 60.0
    /// y偏移量
    private let _marginY: CGFloat = 0.0
    /// 试图高度
    private let _headViewHeight: CGFloat = 50.0
    /// 线条高度
    private let _lineHeight: CGFloat = 6.0
    /// 线条宽度
    private let _lineWidth: CGFloat = 20.0
    /// 最大角度
    private let _maxAngle: CGFloat = CGFloat.pi / 8.0
    /// 记录状态
    private var _status: _TransitionStatusEnum = .normal
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let scrollView = object as? UIScrollView, let keyPath = keyPath else { return }
        if keyPath == "contentOffset" {
            if !scrollView.isDragging {
                if self._status == .willCallBack {
                    self._status = .callBack
                    DispatchQueue.main.async {
                        self._block?()
                    }
                }
            } else {
                let offset = (change?[.newKey] as? NSValue)?.cgPointValue ?? CGPoint.zero
                var angle: CGFloat = -(scrollView.contentInset.top + offset.y) / _transitionMinNum * _maxAngle
                angle = angle < 0.0 ? 0.0 : angle
                
                if angle >= _maxAngle {
                    angle = _maxAngle
                    self._leftLine.backgroundColor = UIColor.red
                    self._rightLine.backgroundColor = UIColor.red
                    self._status = .willCallBack
                } else {
                    self._leftLine.backgroundColor = UIColor.lightGray
                    self._rightLine.backgroundColor = UIColor.lightGray
                    self._status = .normal
                }
                self._leftLine.transform = CGAffineTransform.init(rotationAngle: angle)
                self._rightLine.transform = CGAffineTransform.init(rotationAngle: -angle)
            }
        }
    }
    
    /// 左线条
    private lazy var _leftLine: UIImageView! = {
        let leftLine = UIImageView()
        leftLine.layer.cornerRadius = _lineHeight / 2.0
        leftLine.backgroundColor = UIColor.lightGray
        return leftLine
    }()
    /// 右线条
    private lazy var _rightLine: UIImageView! = {
        let rightLine = UIImageView()
        rightLine.layer.cornerRadius = _lineHeight / 2.0
        rightLine.backgroundColor = UIColor.lightGray
        return rightLine
    }()
}
