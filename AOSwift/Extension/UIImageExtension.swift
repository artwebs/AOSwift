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
        let imageW:CGFloat = self.size.width
        let imageH:CGFloat = self.size.height
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil,width: Int(imageW),height: Int(imageH),bitsPerComponent: 8,bytesPerRow: 0,space: colorSpace,bitmapInfo: CGImageAlphaInfo.none.rawValue)
        if(context == nil){
            return nil
        }
        context?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: imageW, height: imageH))
        return UIImage(cgImage: context!.makeImage()!)
    }
}
