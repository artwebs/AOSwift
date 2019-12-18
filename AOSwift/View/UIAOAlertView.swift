//
//  UIAOAlertView.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/18.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAOAlertView: UIAOView {
    var width:CGFloat = 0
    var height:CGFloat = 0
    
    func show(size:CGSize,from:(UIAOView,UIAOAlertView)->Void){
        let rect = UIScreen.main.bounds
        let alertView = UIView(frame: rect)
        self.width = size.width
        self.height = size.height
        alertView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.width = self.width > rect.width-20 ? rect.width-20:self.width
        self.height = self.height > rect.height-80 ? rect.height-20:self.height
        let container = UIAOView(frame: CGRect(x: 10, y: 40, width: self.width, height: self.height))
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        container.backgroundColor = UIColor.white
        container.center = CGPoint(x: rect.width*0.5, y: rect.height*0.5)
        alertView.addSubview(container)
        self.addSubview(alertView)
        from(container,self)
    }
    
    func close(){
        self.removeFromSuperview()
    }
}
