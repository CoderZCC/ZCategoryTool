//
//  UIViewController+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/13.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// 关闭自动调节
    ///
    /// - Parameter scrollview: 滚动视图
    public func k_setAdjustsScrollviewInsets(_ scrollview: UIScrollView) {
        
        if #available(iOS 11.0, *) {
            scrollview.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}
