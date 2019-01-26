//
//  UtilHelper.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/1/26.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class UtilHelper {
    class func drawGradual(view:UIView,rect:CGRect,startColor:UIColor,endColor:UIColor){
        let layer = CAGradientLayer()
        layer.frame = rect
        ///设置颜色
        layer.colors = [startColor.cgColor,endColor.cgColor]
        ///设置颜色渐变的位置 （我这里是横向 中间点开始变化）
        layer.locations = [0,1]
        ///开始的坐标点
        layer.startPoint = CGPoint(x: 0, y: 0)
        ///结束的坐标点
        layer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.addSublayer(layer)
    }
}
