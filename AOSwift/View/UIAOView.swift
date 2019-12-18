//
//  UIAOView.swift
//  HongMengPF
//
//  Created by 刘洪彬 on 2019/10/28.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAOView: UIView {
    var views = Dictionary<String,UIView>()
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
 
 
 

    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.white
    }
     */
    
    func color(startColor:UIColor,endColor:UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [startColor,endColor]
        let gradientLocations:[NSNumber] = [0.0,1.0]
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
    }
}
