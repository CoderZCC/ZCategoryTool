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
        self.view.addSubview(self.imgV)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let img = UIImage.init(named: "img")?.k_compressImage(size: CGSize.init(width: 100.0, height: 100.0), maxSize: 20)
        
        self.imgV.image = UIImage.init(data: img!)
    }

    lazy var imgV: UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0))
        imgV.center = self.view.center
        
        return imgV
    }()
}
