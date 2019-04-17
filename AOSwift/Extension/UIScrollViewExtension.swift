//
//  UIScrollViewExtension.swift
//  RuralCadre
//
//  Created by rsmac on 15/9/11.
//  Copyright (c) 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit

extension UIScrollView{
    //滚动到中心位置
    func setContentOffViewCenter(view :UIView){
        if self.contentSize.width<self.frame.width{
            return;
        }
        var posx = view.center.x - self.frame.width*0.5
        if posx<0 {
            posx = 0
        }else if(self.contentSize.width - posx < self.frame.width){
            posx = self.contentSize.width - self.frame.width
        }
        self.setContentOffset(CGPoint(x: posx, y: 0), animated: true)
    }
    

}
