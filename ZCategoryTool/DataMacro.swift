//
//  DataMacro.swift
//  HmmProject
//
//  Created by 张崇超 on 2018/10/19.
//  Copyright © 2018 Hmm. All rights reserved.
//

import UIKit

/// 屏幕宽
let kWidth: CGFloat = UIScreen.main.bounds.size.width
/// 屏幕高
let kHeight: CGFloat = UIScreen.main.bounds.size.height

///  打印类的所有实例变量
///
/// - Parameter cls: 目标类
func kPrintIvars(_ cls: AnyClass) {
    print("开始打印,实例变量 =======")
    var count: UInt32 = 0
    let ivars = class_copyIvarList(cls, &count)
    for i in 0 ..< count {
        let ivar = ivars![Int(i)]
        print(String(utf8String: ivar_getName(ivar)!) ?? "")
    }
    free(ivars)
    print("结束打印 =======")
}

///  打印类的所有属性变量
///
/// - Parameter cls: 目标类
func kPrintProperties(_ cls: AnyClass) {
    print("开始打印,属性变量 =======")
    var count: UInt32 = 0
    let properties = class_copyPropertyList(cls, &count)
    for i in 0 ..< count {
        let property = properties![Int(i)]
        print(String(utf8String: property_getName(property)) ?? "")
    }
    free(properties)
    print("结束打印 =======")
}

/// 打印类的所有方法
///
/// - Parameter cls: 目标类
func kPrintMethods(_ cls: AnyClass) {
    print("开始打印,所有方法 =======")
    var count: UInt32 = 0
    let methods = class_copyMethodList(cls, &count)
    for i in 0 ..< count {
        let method = methods![Int(i)]
        print(method_getName(method))
    }
    free(methods)
    print("结束打印 =======")
}
