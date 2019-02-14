//
//  AppDelegate+Ext.swift
//  HmmProject
//
//  Created by 张崇超 on 2018/10/19.
//  Copyright © 2018 Hmm. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    /// 赋值常量
    public func k_setDataMacro() {
        
        kWindow = window
        if #available(iOS 11.0, *) {
            
            kTopSafeArea = window?.safeAreaInsets.top ?? 0.0
            kBottomSafeArea = window?.safeAreaInsets.bottom ?? 0.0
            
        } else {
            
            kTopSafeArea = 0.0
            kBottomSafeArea = 0.0
        }
        kIsIphoneX = kTopSafeArea > 0.0
        kIsIphone5 = kWidth <= 320.0
    }
}
