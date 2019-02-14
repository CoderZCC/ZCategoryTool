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

extension NSObject {
    
    /// 当前活跃的导航栏
    public var k_navigationVC: UINavigationController? {
        return self.navigationVC()
    }
    /// 当前活跃的控制器
    public var k_currentVC: UIViewController {
        return self.getCurrentVC()
    }
    /// 当前活跃的导航栏
    ///
    /// - Returns: 导航栏
    fileprivate func navigationVC(checkVC: UIViewController? = nil) -> UINavigationController? {
        
        let rootVC = checkVC == nil ? (kRootVC) : (checkVC)
        if let tabBarVC = rootVC as? UITabBarController {
            
            // 标签栏 + 导航栏
            return tabBarVC.selectedViewController as? UINavigationController
            
        } else if let navVC = rootVC as? UINavigationController {
            
            // 导航栏
            return navVC
        }
        return nil
    }
    
    /// 当前活跃的控制器
    ///
    /// - Returns: 控制器
    fileprivate func getCurrentVC(checkVC: UIViewController? = nil) -> UIViewController {
        
        var rVC: UIViewController = checkVC == nil ? (kRootVC) : (checkVC!)
        var currentVC: UIViewController!
        
        // 弹出试图判断
        if rVC.presentedViewController != nil {
            
            rVC = rVC.presentedViewController!
        }
        if let tabBarVC = rVC as? UITabBarController {
            
            currentVC = self.getCurrentVC(checkVC: tabBarVC.selectedViewController!)
            
        } else if let navVC = rVC as? UINavigationController {
            
            currentVC = self.getCurrentVC(checkVC: navVC.visibleViewController!)
            
        } else {
            
            currentVC = rVC
        }
        return currentVC
    }
}

