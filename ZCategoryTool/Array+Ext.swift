//
//  Array+Ext.swift
//  ZCategoryToolDemo
//
//  Created by ZCC on 2019/4/11.
//  Copyright © 2019 zcc. All rights reserved.
//

import UIKit

// MARK: - 操作数组
extension Array {
    
    ///  替换元素
    ///
    /// - Parameters:
    ///   - index: 替换的下标
    ///   - element: 要替换的元素
    public mutating func k_replaceElement(at index: Int, with element: Element) {
        if index > count - 1 || index < 0 {
            return
        }
        replaceSubrange(index ..< index + 1, with: [element])
    }
}

extension Array {
    
    /// 防止数组越界
    ///
    /// - Parameter index: 下标
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
