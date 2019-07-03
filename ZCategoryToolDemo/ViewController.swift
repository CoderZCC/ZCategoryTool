//
//  ViewController.swift
//  ZCategoryToolDemo
//
//  Created by ZCC on 2019/2/11.
//  Copyright © 2019 zcc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        
        let textField = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 35.0))
        textField.backgroundColor = UIColor.black
        textField.center = self.view.center
        textField.keyboardAppearance = .dark
        textField.tintColor = UIColor.white
        textField.textColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.returnKeyType = .search
        textField.placeholder = "查找笔记"
        textField.k_placeholderColor = UIColor.white
        
        self.view.addSubview(textField)
    }
    
    deinit {
        print("\(self)销毁了")
    }
}
