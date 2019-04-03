//
//  NSObject+Ext.swift
//  ZCategoryToolDemo
//
//  Created by ZCC on 2019/4/3.
//  Copyright © 2019 zcc. All rights reserved.
//

import UIKit

extension NSObject {
    
    /// 动态添加属性
    ///
    /// - Parameters:
    ///   - key: 唯一值
    ///   - value: 保存的值
    func k_setAssociatedObject(key: String, value: Any?) {
        guard let keyHashValue = UnsafeRawPointer(bitPattern: key.hashValue) else { return }
        objc_setAssociatedObject(self, keyHashValue, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// 获取属性值
    ///
    /// - Parameter key: 唯一值
    /// - Returns: 保存的值
    func k_getAssociatedObject(key: String) -> Any? {
        guard let keyHashValue = UnsafeRawPointer(bitPattern: key.hashValue) else { return nil }
        return objc_getAssociatedObject(self, keyHashValue)
    }
}
