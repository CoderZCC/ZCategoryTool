//
//  ViewController.swift
//  ZCategoryToolDemo
//
//  Created by 张崇超 on 2019/2/11.
//  Copyright © 2019 zcc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.textView)
    }
    
    lazy var textView: UITextView = {
        let textView = UITextView.init(frame: CGRect(x: 20.0, y: 34.0, width: kWidth - 40.0, height: 150.0))
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.k_placeholder = "请填写请填写请填写请填写请填写请填写请填写请填写请填写请填写请填写请填写请填写请填写请填写请填写请填写请填写"
        textView.k_placeholderColor = UIColor.red
        
        return textView
    }()
}
