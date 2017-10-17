//
//  LoadingCircleView.swift
//  zcapp
//
//  Created by 刘洪彬 on 2017/10/17.
//  Copyright © 2017年 Dali Fuzee Technology Co. LTD. All rights reserved.
//

import UIKit

@objc protocol LoadingCircleViewDelegate{
     @objc optional func loadingCircleViewFromBackground(_ loadingView : LoadingCircleView , size: CGSize)->UIView;
     @objc optional func loadingCircleViewFromProgress(_ loadingView : LoadingCircleView , size: CGSize)->UIView;
}


class LoadingCircleView: UIView {
    var backgroundView : UIView?
    var progressView : UIView?
    var delegate : LoadingCircleViewDelegate?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     */
    override func draw(_ rect: CGRect) {
        
    }
    
    func reload()  {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.backgroundView = self.delegate?.loadingCircleViewFromBackground?(self, size: frame.size)
        self.progressView = self.delegate?.loadingCircleViewFromProgress?(self, size: frame.size)
        
        if let v = self.backgroundView {
            v.center = CGPoint(x: frame.width  * 0.5, y: frame.height * 0.5)
            self.addSubview(v)
        }
        
        if let v = self.progressView {
            v.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
            self.addSubview(v)
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
            rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0) // 旋转角度
            rotationAnimation.duration = 0.6 // 旋转周期
            rotationAnimation.isCumulative = true // 旋转累加角度
            rotationAnimation.repeatCount = 100000 // 旋转次数
            v.layer.add(rotationAnimation, forKey: "rotationAnimation")
            
        }
        self.isHidden = true
    }
    

}
