//
//  FlashHorizontalView.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/16.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


protocol UIAOFlashHorizontalViewDataSource{
    func flashHorizontalViewCellCount(_ flashView : UIAOFlashHorizontalView)->Int
    func flashHorizontalViewForCell(_ flashView : UIAOFlashHorizontalView,cell : UIButton,index: Int)
}

protocol UIAOFlashHorizontalViewDelegate{
    func flashHorizontalViewDidSelectedCell(_ flashView : UIAOFlashHorizontalView,index: Int)
}

class UIAOFlashHorizontalView: UIScrollView {
    var dataSource : UIAOFlashHorizontalViewDataSource?
    var flashDelegate : UIAOFlashHorizontalViewDelegate?
    
    var startTag : Int{
        get{
            return 10300
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func reload(){
        self.backgroundColor = UIColor.clear
        for view in self.subviews {
            view.removeFromSuperview()
        }
        if dataSource == nil{
            return;
        }
        var allWidth : CGFloat = 0
        if let count = dataSource?.flashHorizontalViewCellCount(self){
            for index in 0..<count{
                let view = UIButton(frame: CGRect(x: allWidth,y: 0,width: frame.width,height: frame.height))
                self.dataSource!.flashHorizontalViewForCell(self, cell:view,index: index)
                view.addTarget(self, action: #selector(UIAOFlashHorizontalView.btnOnClick(_:)), for: UIControl.Event.touchUpInside)
                view.setTag(index+startTag)
                allWidth += view.frame.width
                self.addSubview(view)
            }
        }
        self.contentSize = CGSize(width: allWidth, height: frame.height)
        self.isPagingEnabled=true
    }
    
    @objc func btnOnClick( _ sender: UIButton){
        flashDelegate?.flashHorizontalViewDidSelectedCell(self, index: sender.tag()-startTag)
    }
    
    
    

}
