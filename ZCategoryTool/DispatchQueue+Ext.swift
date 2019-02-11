//
//  DispatchQueue+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension DispatchQueue {
    
    //MARK: 异步提交延迟操作到主线程
    /// 异步提交延迟操作到主线程
    ///
    /// - Parameters:
    ///   - dealyTime: 延迟时间 相对于当前时间
    ///   - callBack: 回调
    static func k_asyncAfterOnMain(dealyTime: Double, callBack: (()->Void)?) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dealyTime) {
            
            callBack?()
        }
    }
    
    //MARK: 异步提交延迟操作到全局子线程
    /// 异步提交延迟操作到全局子线程
    ///
    /// - Parameters:
    ///   - dealyTime: 延迟时间 相对于当前时间
    ///   - callBack: 回调
    func k_asyncAfterOnBack(dealyTime: Double, callBack: (()->Void)?) {
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + dealyTime) {
            
            callBack?()
        }
    }
}
