//
//  UIScrollView+Ext.swift
//  ZCategoryToolDemo
//
//  Created by 张崇超 on 2019/2/14.
//  Copyright © 2019 zcc. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let tapView = super.hitTest(point, with: event)
        if let tapView = tapView {
            
            self.isScrollEnabled = !(tapView.isKind(of: UISlider.self))
        }
        return tapView
    }
}
