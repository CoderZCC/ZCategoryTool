//
//  UIImage+Ext.swift
//  ExtensionTool
//
//  Created by ZCC on 2018/7/10.
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
    
    /// 获取图片某一点的颜色
    ///
    /// - Parameter point: 目标点，x、y为0-1之间的数，表示在图片中的点的比例位置
    /// - Returns: 得到的颜色
    public func k_getColor(at point: CGPoint) -> UIColor? {
        guard let imageRef = cgImage else { return nil }
        let realPointX = Int(CGFloat(imageRef.width) * point.x) + 1
        let realPointY = Int(CGFloat(imageRef.height) * point.y) + 1
        let rect = CGRect(x: 0, y: 0, width: CGFloat(imageRef.width), height: CGFloat(imageRef.height))
        let realPoint = CGPoint(x: realPointX, y: realPointY)
        guard rect.contains(realPoint) else { return nil }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        guard let context = CGContext(data: pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        context.setBlendMode(.copy)
        context.translateBy(x:  -CGFloat(realPointX), y: CGFloat(realPointY - imageRef.height))
        context.draw(imageRef, in: rect)
        let red = CGFloat(pixelData[0]) / 255
        let green = CGFloat(pixelData[1]) / 255
        let blue = CGFloat(pixelData[2]) / 255
        let alpha = CGFloat(pixelData[3]) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 重新布局图片, 会被挤扁
    ///
    /// - Parameter newSize: 新尺寸
    /// - Returns: 新图片
    public func k_resizeImage(with newSize: CGSize) -> UIImage {
        
        let newWidth = newSize.width
        let newHeight = newSize.height
        
        let width = self.size.width * self.scale
        let height = self.size.height * self.scale
        
        if (width != newWidth) || (height != newHeight) {
            
            UIGraphicsBeginImageContextWithOptions(newSize, true, UIScreen.main.scale)
            self.draw(in: CGRect(x: 0.0, y: 0.0, width: newWidth, height: newHeight))
            
            let resized = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resized ?? self
        }
        return self
    }
    
    /// 等比压缩，然后裁剪为想要的尺寸
    ///
    /// - Parameter newSize: 尺寸
    /// - Returns: 新图
    public func k_scaleSquareImage(newSize: CGSize) -> UIImage? {
        let asecptImg = self.k_cropImageWith(newSize: newSize)
        return asecptImg.k_resizeImage(with: newSize)
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
    
    // MARK: - 降低质量
    /// 压缩图片
    ///
    /// - Parameters:
    ///   - size: 新尺寸
    ///   - maxSize: 最大kb
    /// - Returns: 数据流
    public func k_compressImage(size: CGSize? = nil, maxSize: Int) -> Data? {
        
        var cropImage: UIImage!
        if let size = size, size != CGSize.zero {
            cropImage = self.k_scaleSquareImage(newSize: size)
        } else {
            cropImage = self
        }
        //先判断当前质量是否满足要求，不满足再进行压缩
        var finallImageData = cropImage.jpegData(compressionQuality: 1.0)
        guard let sizeOrigin = finallImageData?.count else { return nil }
        let sizeOriginKB = sizeOrigin / 1024
        if sizeOriginKB <= maxSize {
            return finallImageData
        }
        
        //获取原图片宽高比
        let sourceImageAspectRatio = cropImage.size.width/cropImage.size.height
        //先调整分辨率
        var defaultSize = size ?? CGSize(width: 500, height: 500/sourceImageAspectRatio)
        var newImage: UIImage!
        if size == nil {
            newImage = cropImage.newSizeImage(size: defaultSize)
        } else {
            newImage = cropImage
        }
        
        finallImageData = newImage.jpegData(compressionQuality: 1.0)
        
        //保存压缩系数
        let compressionQualityArr = NSMutableArray()
        let avg = CGFloat(1.0/250)
        var value = avg
        
        var i = 250
        repeat {
            i -= 1
            value = CGFloat(i)*avg
            compressionQualityArr.add(value)
        } while i >= 1
        
        /*
         调整大小
         说明：压缩系数数组compressionQualityArr是从大到小存储。
         */
        //思路：使用二分法搜索
        finallImageData = newImage.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], sourceData: finallImageData!, maxSize: maxSize)
        //如果还是未能压缩到指定大小，则进行降分辨率
        while finallImageData?.count == 0 {
            //每次降100分辨率
            let reduceWidth = 100.0
            let reduceHeight = 100.0/sourceImageAspectRatio
            if (defaultSize.width-CGFloat(reduceWidth)) <= 0 || (defaultSize.height-CGFloat(reduceHeight)) <= 0 {
                break
            }
            defaultSize = CGSize(width: (defaultSize.width-CGFloat(reduceWidth)), height: (defaultSize.height-CGFloat(reduceHeight)))
            let image = UIImage.init(data: newImage.jpegData(compressionQuality: compressionQualityArr.lastObject as! CGFloat)!)!.newSizeImage(size: defaultSize)
            
            finallImageData = image.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], sourceData: image.jpegData(compressionQuality: 1.0)!, maxSize: maxSize)
        }
        
        return finallImageData
    }
    
    // MARK: - 调整图片分辨率/尺寸（等比例缩放）
    private func newSizeImage(size: CGSize) -> UIImage {
        var newSize = CGSize(width: self.size.width, height: self.size.height)
        let tempHeight = newSize.height / size.height
        let tempWidth = newSize.width / size.width
        
        if tempWidth > 1.0 && tempWidth > tempHeight {
            newSize = CGSize(width: self.size.width / tempWidth, height: self.size.height / tempWidth)
        } else if tempHeight > 1.0 && tempWidth < tempHeight {
            newSize = CGSize(width: self.size.width / tempHeight, height: self.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // MARK: - 二分法
    private func halfFuntion(arr: [CGFloat], sourceData finallImageData: Data, maxSize: Int) -> Data? {
        var tempFinallImageData = finallImageData
        
        var tempData = Data.init()
        var start = 0
        var end = arr.count - 1
        var index = 0
        
        var difference = Int.max
        while start <= end {
            index = start + (end - start)/2
            
            tempFinallImageData = self.jpegData(compressionQuality: arr[index])!
            
            let sizeOrigin = tempFinallImageData.count
            let sizeOriginKB = sizeOrigin / 1024
            
            print("当前降到的质量：\(sizeOriginKB)\n\(index)----\(arr[index])")
            
            if sizeOriginKB > maxSize {
                start = index + 1
            } else if sizeOriginKB < maxSize {
                if maxSize-sizeOriginKB < difference {
                    difference = maxSize-sizeOriginKB
                    tempData = tempFinallImageData
                }
                if index<=0 {
                    break
                }
                end = index - 1
            } else {
                break
            }
        }
        return tempData
    }
}

extension UIImage {
    
    //MARK: - ciImage生成高清的UIImage
    /// ciImage生成高清图
    ///
    /// - Parameter size: 尺寸 eg: 300
    /// - Returns: 新图
    public func k_createHighDefinitionImage(size: CGFloat? = nil) -> UIImage? {
        
        guard let image = self.ciImage else { return self }
        let newSize: CGFloat = size ?? self.size.width
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(newSize / integral.width, newSize / integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        if let bitmapImage: CGImage = context.createCGImage(image, from: integral) {
            bitmapRef.interpolationQuality = CGInterpolationQuality.none
            bitmapRef.scaleBy(x: proportion, y: proportion);
            bitmapRef.draw(bitmapImage, in: integral);
            if let image: CGImage = bitmapRef.makeImage() {
                return UIImage(cgImage: image)
            }
            return self
        }
        return self
    }
}

extension UIImage {
    
    /// 读取二维码
    ///
    /// - Parameter block: 回调
    public func k_readQRCode(block: (([String]?)->Void)?) {
        guard let cgImage = self.cgImage else {
            DispatchQueue.main.async {
                block?(nil)
            }
            return
        }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let features = detector?.features(in: CoreImage.CIImage(cgImage: cgImage))
        var arr: [String] = []
        for obj in features ?? [] {
            if let str = (obj as? CIQRCodeFeature)?.messageString {
                arr.append(str)
            }
        }
        DispatchQueue.main.async {
            block?(arr)
        }
    }
}
