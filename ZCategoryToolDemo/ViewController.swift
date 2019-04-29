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

        let btn = UIButton.init(type: UIButton.ButtonType.contactAdd)
        btn.center = self.view.center
        btn.sizeToFit()
        btn.k_addTarget {
        
            DispatchQueue.global().async {
                "http://".k_createQRCode(centerImg: UIImage.init(named: "img"), block: { (img) in
                    
                    let newImgV = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: 300.0, height: 300.0))
                    newImgV.center = self.view.center
                    newImgV.image = img
                    self.view.addSubview(newImgV)
                })
            }
            
        }
        
        self.view.addSubview(btn)
        
    }
}
