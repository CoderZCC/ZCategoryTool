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
        
//        let btn = UIButton.init(type: UIButton.ButtonType.contactAdd)
//        btn.sizeToFit()
//        btn.center = self.view.center
//        self.view.addSubview(btn)
//        btn.addTarget(events: UIControl.Event.touchUpInside, inTarget: self) { (weakBtn, weakSelf) in
//
//            print(weakBtn)
//            print(weakSelf)
//            weakSelf.present(ViewController1(), animated: true, completion: nil)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.present(ViewController1(), animated: true, completion: nil)
    }
    
    deinit {
        print("\(self)销毁了")
    }
}

class ViewController1: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.darkGray
        
        
        let imgV = UIImageView.init(image: UIImage.init(named: "img"))
        imgV.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        imgV.center = self.view.center
        self.view.addSubview(imgV)
        imgV.addTapGesture(target: self) { (tap, weakSelf) in
            
            print(tap)
            print(weakSelf)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("\(self)销毁了")
    }
}

