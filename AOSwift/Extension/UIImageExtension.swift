//
//  UIImageExtension.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/1/26.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

extension UIImage{
    func toGrayImage()->UIImage?{
        guard let imageCG = self.cgImage else {
            return nil
        }
        let width = imageCG.width
        let height = imageCG.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // 申请内存空间
        let pixels = UnsafeMutablePointer<UInt32>.allocate(capacity: width * height )
        //UInt32在计算机中所占的字节
        let uint32Size = MemoryLayout<UInt32>.size
        let context = CGContext.init(data: pixels,
                                     width: width,
                                     height: height,
                                     bitsPerComponent: 8,
                                     bytesPerRow: uint32Size * width,
                                     space: colorSpace,
                                     bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(imageCG, in: CGRect(x: 0, y: 0, width: width, height: height))
        for y in 0 ..< height {
            for x in 0 ..< width {
                let rgbaPixel = pixels.advanced(by: y * width + x)
                //类型转换 -> UInt8
                let rgb = unsafeBitCast(rgbaPixel, to: UnsafeMutablePointer<UInt8>.self)
                // rgba 所在位置 alpha 0, blue  1, green 2, red 3
                let gray = UInt8(0.3  * Double(rgb[3]) +
                    0.59 * Double(rgb[2]) +
                    0.11 * Double(rgb[1]))
                rgb[3] = gray
                rgb[2] = gray
                rgb[1] = gray
            }
        }
        guard let image = context?.makeImage() else {
            return nil
        }
        return UIImage(cgImage: image, scale: 0, orientation: self.imageOrientation)
    }
    
    public func reSize(size: CGSize) -> UIImage? {
        if self.size.height > size.height {
            let width = size.height / self.size.height * self.size.width
            let newImgSize = CGSize(width: width, height: size.height)
            UIGraphicsBeginImageContext(newImgSize)
            self.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let newImg = theImage else { return  nil}
            return newImg
            
        } else {
            let newImgSize = CGSize(width: size.width, height: size.height)
            UIGraphicsBeginImageContext(newImgSize)
            self.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let newImg = theImage else { return  nil}
            return newImg
        }
    
    }
    
    
}
