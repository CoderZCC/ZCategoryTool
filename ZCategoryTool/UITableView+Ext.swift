//
//  UITableView+Ext.swift
//  OrderManager
//
//  Created by 张崇超 on 2018/7/11.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit

extension UITableView {
    
    //MARK: 隐藏多余的线
    /// 隐藏多余的线
    public func k_hiddeLine() {
        
        self.tableFooterView = UIView()
    }
    
    //MARK: 注册单元格 使用类名作为标记符
    /// 注册单元格 使用类名作为标记符
    ///
    /// - Parameter cls: 单元格
    public func k_registerCell(cls: AnyClass) {
        
        self.register(cls, forCellReuseIdentifier: self.k_StrFrom(cls))
    }
    /// 注册单元格 使用类名作为标记符
    ///
    /// - Parameter cls: 单元格
    public func k_registerNibCell(cls: AnyClass) {
        
        self.register(UINib.init(nibName: self.k_StrFrom(cls), bundle: nil), forCellReuseIdentifier: self.k_StrFrom(cls))
    }
    //MARK: 获取注册的单元格
    /// 获取注册的单元格
    ///
    /// - Parameters:
    ///   - cls: 类名
    ///   - indexPath: indexPath
    public func k_dequeueReusableCell <T> (cls: T.Type, indexPath: IndexPath) -> T {
        
        return self.dequeueReusableCell(withIdentifier: "\(cls)".components(separatedBy: ".").last!, for: indexPath) as! T
    }
}

extension UIScrollView {
    
    /// 获取
    ///
    /// - Parameter cls: 类名
    /// - Returns: 字符串
    public func k_StrFrom(_ cls: AnyClass) -> String {
        
        let xibName = NSStringFromClass(cls).components(separatedBy: ".").last!
        return xibName
    }
}

extension UICollectionView {
    
    //MARK: 注册单元格 使用类名作为标记符
    /// 注册单元格 使用类名作为标记符
    ///
    /// - Parameter cls: 单元格
    public func k_registerCell(cls: AnyClass) {
        
        self.register(cls, forCellWithReuseIdentifier: self.k_StrFrom(cls))
    }
    /// 注册单元格 使用类名作为标记符
    ///
    /// - Parameter cls: 单元格
    public func k_registerNibCell(cls: AnyClass) {

        self.register(UINib.init(nibName: self.k_StrFrom(cls), bundle: nil), forCellWithReuseIdentifier: self.k_StrFrom(cls))
    }
    //MARK: 获取注册的单元格
    /// 获取注册的单元格
    ///
    /// - Parameters:
    ///   - cls: 类名
    ///   - indexPath: indexPath
    public func k_dequeueReusableCell <T> (cls: T.Type, indexPath: IndexPath) -> T {
        
        return self.dequeueReusableCell(withReuseIdentifier: "\(cls)".components(separatedBy: ".").last!, for: indexPath) as! T
    }
}
