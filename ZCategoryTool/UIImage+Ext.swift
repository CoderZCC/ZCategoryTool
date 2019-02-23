//
//  UIImage+Ext.swift
//  ExtensionTool
//
//  Created by 张崇超 on 2018/7/10.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import CoreFoundation

extension UIImage {

    /// 根据颜色创建一个图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 图片
    public static func k_imageWithColor(_ color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let ref = UIGraphicsGetCurrentContext()
        ref?.setFillColor(color.cgColor)
        ref?.fill(rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img
    }
    
    /// 重新布局图片
    ///
    /// - Parameter newSize: 新尺寸
    /// - Returns: 新图片
    public func k_resizeImage(with newSize: CGSize) -> UIImage {
        
        let newWidth = newSize.width
        let newHeight = newSize.height
        
        let width = self.size.width
        let height = self.size.height
        
        if (width != newWidth) || (height != newHeight) {
            
            UIGraphicsBeginImageContextWithOptions(newSize, true, UIScreen.main.scale)
            self.draw(in: CGRect(x: 0.0, y: 0.0, width: newWidth, height: newHeight))
            
            let resized = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resized ?? self
        }
        return self
    }
    
    /// 以图片中心为中心，以最小边为边长，裁剪正方形图片
    ///
    /// - Returns: 新图片
    public func k_cropSquareImage() -> UIImage {
        
        let cgImg = self.cgImage
        let imgWidth = self.size.width * self.scale
        let imgHeight = self.size.height * self.scale
        let cropWidth = min(imgWidth, imgHeight)
        let offSetX = (imgWidth - cropWidth) / 2.0
        let offSetY = (imgHeight - cropWidth) / 2.0
        let rect = CGRect.init(x: offSetX, y: offSetY, width: cropWidth, height: cropWidth)
        
        if let cropCgImg = cgImg?.cropping(to: rect) {
            return UIImage.init(cgImage: cropCgImg)
        }
        return self
    }
    
    /// 从（0，0）裁剪图片尺寸
    ///
    /// - Parameter size: 新尺寸
    /// - Returns: 新图片
    public func k_cropImageAtOriginal(newSize: CGSize) -> UIImage {
        
        let imgWidth = self.size.width * self.scale
        let imgHeight = self.size.height * self.scale
        if newSize.width >= imgWidth && newSize.height >= imgHeight { return self }
        let scale = imgWidth / imgHeight
        var rect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        
        if scale > newSize.width / newSize.height {
            
            rect.size.width = imgHeight * newSize.width / newSize.height
            rect.size.height = imgHeight
            
        } else {
            
            rect.size.width = imgWidth
            rect.size.height = imgWidth / newSize.width * newSize.height
        }
        if let imgRef = self.cgImage?.cropping(to: rect) {
            return UIImage.init(cgImage: imgRef)
        }
        return self
    }
    
    /// 从中心裁剪图片尺寸
    ///
    /// - Parameter size: 修改的尺寸
    /// - Returns: 新图片
    public func k_cropImageWith(newSize: CGSize) -> UIImage {
        
        let imgWidth = self.size.width * self.scale
        let imgHeight = self.size.height * self.scale
        if newSize.width >= imgWidth && newSize.height >= imgHeight { return self }
        let scale = imgWidth / imgHeight
        var rect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        
        if scale > newSize.width / newSize.height {
            
            rect.size.width = imgHeight * newSize.width / newSize.height
            rect.origin.x = (imgWidth - rect.size.width) / 2.0
            rect.size.height = imgHeight
            
        } else {
            
            rect.origin.y = (imgHeight - imgWidth / newSize.width * newSize.height) / 2.0
            rect.size.width = imgWidth
            rect.size.height = imgWidth / newSize.width * newSize.height
        }
        if let imgRef = self.cgImage?.cropping(to: rect) {
            return UIImage.init(cgImage: imgRef)
        }
        return self
    }
    
    //MARK: 裁剪圆形为圆形
    /// 裁剪为圆形图片
    ///
    /// - Parameters:
    ///   - backColor: 裁剪为圆形 空白区域的背景颜色 默认白色
    ///   - borderColor: 边框颜色
    ///   - borderWidth: 边框宽度
    /// - Returns: 新图片
    public func k_circleImage(backColor: UIColor? = UIColor.white, borderColor: UIColor? = nil, borderWidth: CGFloat? = 0.0) -> UIImage {
        
        // 圆形图片
        let imgW: CGFloat = self.size.width * self.scale
        let imgH: CGFloat = self.size.height * self.scale
        let imgWH: CGFloat = min(imgW, imgH)
        let squareImg = self.k_cropImageWith(newSize: CGSize.init(width: imgWH, height: imgWH))
        // 圆形框
        let rect = CGRect(origin: CGPoint(), size: squareImg.size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
        // 填充
        (backColor ?? UIColor.white).setFill()
        UIRectFill(rect)
        
        // 形状
        let circlePath = UIBezierPath.init(ovalIn: rect)
        circlePath.addClip()
        
        squareImg.draw(in: rect)
        
        // 是否有边框
        if let borderColor = borderColor {
            
            borderColor.setStroke()
            circlePath.lineWidth = borderWidth ?? 1.0
            circlePath.stroke()
        }
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result ?? self
    }
    
    /// 压缩图片kb大小
    ///
    /// - Parameters:
    ///   - newSize: 压缩完后图片的新尺寸(中心裁剪), 默认为原图
    ///   - imgKB: 压缩完后图片的新大小 kb单位
    ///   - block: 回调
    public func k_compressImage(newSize: CGSize? = nil, imgKB: CGFloat, block: ((UIImage)->Void)?) {
        
        var cropImg: UIImage!
        // 先裁剪为想要的尺寸
        if let newSize = newSize, newSize != CGSize.zero {
            cropImg = self.k_cropImageWith(newSize: newSize)
        } else {
            cropImg = self
        }
        if imgKB <= 0.0 {
            DispatchQueue.main.async {
                block?(cropImg)
            }
            return
        }
        
        var uploadImageData: Data = cropImg.pngData() ?? Data()
        let uploadImageByte: CGFloat = CGFloat(uploadImageData.count) / 1024.0
        debugPrint("压缩前的大小:\(uploadImageByte)")
        let imgWidth: CGFloat = self.size.width * self.scale
        let imgHeight: CGFloat = self.size.height * self.scale
        
        if uploadImageByte > imgKB {
            
            // 提交到子线程
            DispatchQueue.global().async {
                
                // 宽高比例
                let ratioOfWH = imgWidth / imgHeight
                // 压缩率
                let compressionRation = imgKB / uploadImageByte
                // 宽度或高度的压缩率
                let widthOrHeightPressRation = sqrt(compressionRation)
                
                var dWidth = imgWidth * widthOrHeightPressRation
                var dHeight = imgHeight * widthOrHeightPressRation
                if ratioOfWH > 0 {
                    dHeight = dWidth / ratioOfWH
                } else {
                    dWidth = dHeight * ratioOfWH
                }
                cropImg = self.drawWithImage(width: dWidth, height: dHeight)
                uploadImageData = cropImg.pngData() ?? Data()
                debugPrint("尺寸压缩后大小是:\(CGFloat(uploadImageData.count) / 1024.0)")
                
                var compressCount: Int = 0
                while abs(CGFloat(uploadImageData.count) - imgKB) > 1024.0 {
                    
                    let nextPressRation: CGFloat = 0.9
                    if CGFloat(uploadImageData.count) > imgKB {
                        dWidth = dWidth * nextPressRation
                        dHeight = dHeight * nextPressRation
                    } else {
                        dWidth = dWidth / nextPressRation
                        dHeight = dHeight / nextPressRation
                    }
                    cropImg = self.drawWithImage(width: dWidth, height: dHeight)
                    uploadImageData = cropImg.pngData() ?? Data()
                    
                    compressCount += 1
                    if compressCount == 10 {
                        break ;
                    }
                }
                debugPrint("压缩后大小是:\(CGFloat(uploadImageData.count) / 1024.0)")
                cropImg = UIImage.init(data: uploadImageData)
                DispatchQueue.main.async {
                    block?(cropImg)
                }
            }
        } else {
            DispatchQueue.main.async {
                block?(cropImg)
            }
        }
    }
    
    /// 重绘
    private func drawWithImage(width: CGFloat, height: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContext(CGSize.init(width: width, height: height))
        self.draw(in: CGRect.init(x: 0.0, y: 0.0, width: width, height: height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImg ?? self
    }
}
