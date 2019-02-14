//
//  DataMacro.swift
//  HmmProject
//
//  Created by 张崇超 on 2018/10/19.
//  Copyright © 2018 Hmm. All rights reserved.
//

import UIKit

/// 导航栏高度
public let kNavBarHeight: CGFloat = kIsIphoneX ? (88.0) : (64.0)
/// 标签栏高度
public let kTabBarHeight: CGFloat = kIsIphoneX ? (83.0) : (49.0)
/// 屏幕宽
public let kWidth: CGFloat = UIScreen.main.bounds.size.width
/// 屏幕高
public let kHeight: CGFloat = UIScreen.main.bounds.size.height
/// 视频高度
public let kVideoHeight: CGFloat = kWidth * 9.0 / 16.0

/// 是否是iphoneX
public var kIsIphoneX: Bool!
/// 主窗口
public var kWindow: UIWindow!
/// 底部安全区域大小
public var kBottomSafeArea: CGFloat!
/// 顶部安全区域大小
public var kTopSafeArea: CGFloat!
/// 是否是iphone5
public var kIsIphone5: Bool!

/// 系统版本
public let kVersion: Double = Double(UIDevice.current.systemVersion.components(separatedBy: ".").first ?? "0") ?? 0.0

/// 根试图控制器, 单独赋值这个属性
public var kRootVC: UIViewController!
