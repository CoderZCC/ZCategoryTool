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
        
        let imgSize = CGSize(width: kWidth, height: 400.0)
        let image = UIImage(named: "test1")!.k_cropImageAtOriginal(newSize: imgSize)
        
        
        let imgV = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: imgSize.width, height: imgSize.height))
        imgV.backgroundColor = UIColor.darkGray
        imgV.center = self.view.center
        imgV.image = image
        imgV.contentMode = .scaleAspectFit
        
        self.view.addSubview(imgV)
    }
    
    deinit {
        print("\(self)销毁了")
    }
}

extension UIImage {
    
    func k_asecptScaleImage(width: CGFloat) -> UIImage {
        let imgWidth = self.size.width
        let imgHeight = self.size.height
        let scale = width / imgWidth
        let newImgSize = CGSize(width: width, height: scale * imgHeight)
        print(newImgSize)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: newImgSize.width, height: newImgSize.height))
        scrollView.contentSize = scrollView.k_size
        
        let imgV = UIImageView(frame: scrollView.bounds)
        imgV.image = self
        scrollView.addSubview(imgV)
        
        let newImg = scrollView.k_snapshotImage()
        scrollView.removeFromSuperview()
        
        return newImg!
    }
}

