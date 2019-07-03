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
        
        let img1 = UIImage.init(named: "test")
        let imgV1 = UIImageView(image: img1)
        imgV1.contentMode = .scaleAspectFill
        imgV1.clipsToBounds = true
        imgV1.frame = CGRect(x: (kWidth - 300.0) / 2.0, y: 88.0, width: 300.0, height: 300.0)
        self.view.addSubview(imgV1)
        
        let img = UIImage.init(named: "test")?.k_scaleSquareImage(newSize: CGSize(width: 200.0, height: 200.0))
        let imgV = UIImageView(image: img)
        imgV.frame = CGRect(x: imgV1.frame.minX, y: imgV1.frame.maxY + 20.0, width: 300.0, height: 300.0)
        self.view.addSubview(imgV)
    }
}
