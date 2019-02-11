//
//  AVPlayer+Ext.swift
//  HmmProject
//
//  Created by 张崇超 on 2018/12/19.
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
    func k_seekTimeToPlay(time: TimeInterval, isFinish: (() ->Void)? = nil) {
        
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
