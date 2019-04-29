//
//  AVPlayer+Ext.swift
//  HmmProject
//
//  Created by ZCC on 2018/12/19.
//  Copyright © 2018 Hmm. All rights reserved.
//

import UIKit
import AVKit

extension AVPlayer {
    
    /// 快进到指定时间
    ///
    /// - Parameters:
    ///   - time: 时间
    ///   - isFinsish: 快进完成
    public func k_seekTimeToPlay(time: TimeInterval, isFinish: (() ->Void)? = nil) {
        
        self.currentItem?.cancelPendingSeeks()
        let timeScale = self.currentItem?.currentTime().timescale ?? CMTimeScale(1 * NSEC_PER_SEC)
        // 处理时间,保留两位数
        let seekTime = CMTime(seconds: time, preferredTimescale: timeScale)
        self.seek(to: seekTime, toleranceBefore: CMTime(value: 0, timescale: timeScale), toleranceAfter: CMTime(value: 0, timescale: timeScale)) { (isOk) in
            
            DispatchQueue.main.async {
                if isOk { isFinish?() }
            }
        }
    }
}

// MARK: -时间转换
extension CMTime {
    
    /// 转为CGFloat数
    ///
    /// - Returns: 时间
    public func k_toFloat() -> CGFloat {
        return CGFloat(CMTimeGetSeconds(self))
    }
    
    /// 转为Double数
    ///
    /// - Returns: 时间
    public func k_toDouble() -> Double {
        return Double(CMTimeGetSeconds(self))
    }
    
    /// 转为TimeInterval数
    ///
    /// - Returns: 时间
    public func k_toTimeInterval() -> TimeInterval {
        return TimeInterval(CMTimeGetSeconds(self))
    }
}

// MARK: -时间转换
extension TimeInterval {
    
    /// 处理为 00:00格式
    ///
    /// - Returns: 00:00
    public func k_dealString() -> String {
        
        if self.isNaN {
            return "00:00"
        }
        let minute = Int(self / 60.0)
        let second = Int(self.truncatingRemainder(dividingBy: 60.0))
        
        return "\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
    }
}
