//
//  StatusBar+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/10/8.
//  Copyright © 2018 ZCC. All rights reserved.
//

import UIKit

//    plist文件 View controller-based status bar appearance Bool - NO
extension UIResponder {
    
    /// 设置电池条位置
    ///
    /// - Parameter orient: 位置
    public func k_setStatusBarOrientation(_ orient: UIDeviceOrientation) {
        
        DispatchQueue.main.async {
            
            var orientation: UIInterfaceOrientation = .portrait
            if orient == .landscapeLeft || orient == .landscapeRight {
                
                orientation = (orient == .landscapeLeft ? (.landscapeRight) : (.landscapeLeft))
            }
            UIApplication.shared.setStatusBarOrientation(orientation, animated: false)
        }
    }
    
    /// 设置电池条显隐
    ///
    /// - Parameter isHidden: 显隐
    public func k_setStatusBarHidden(_ isHidden: Bool) {
        
        UIApplication.shared.setStatusBarHidden(isHidden, with: UIStatusBarAnimation.fade)
    }
    
    /// 设置电池条风格
    ///
    /// - Parameter style: 风格
    public func k_setStatusBarStyle(_ style: UIStatusBarStyle) {
        
        UIApplication.shared.setStatusBarStyle(style, animated: true)
    }
    
    /// 是否不熄屏
    ///
    /// - Parameter isOk: 是否
    public func k_setIdleTimerDisabled(_ isOk: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = isOk
    }
}

extension UINavigationController {
    
    open override var shouldAutorotate: Bool {
        
        return self.viewControllers.last?.shouldAutorotate ?? false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return self.viewControllers.last?.supportedInterfaceOrientations ?? .portrait
    }
}

extension UITabBarController {

    open override var shouldAutorotate: Bool {

        return self.viewControllers?.first?.shouldAutorotate ?? false
    }
}
