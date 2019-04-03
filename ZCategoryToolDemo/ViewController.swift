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

        let btn = UIButton.init(type: UIButton.ButtonType.contactAdd)
        btn.center = self.view.center
        btn.sizeToFit()
        btn.k_addTarget {
        
            print("aaa")
        }
        
        self.view.addSubview(btn)
        
    }
}
