//
//  FlashHorizontalView.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/16.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit

protocol FlashHorizontalViewDataSource{
    func flashHorizontalViewCellCount(flashView : FlashHorizontalView)->Int
    func flashHorizontalViewForCell(flashView : FlashHorizontalView,cell : UIButton,index: Int)
}

protocol FlashHorizontalViewDelegate{
    func flashHorizontalViewDidSelectedCell(flashView : FlashHorizontalView,index: Int)
}

class FlashHorizontalView: UIScrollView {
    var dataSource : FlashHorizontalViewDataSource?
    var flashDelegate : FlashHorizontalViewDelegate?
    var startTag = 1000
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    
    func reload(){
        for view in self.subviews {
            view.removeFromSuperview()
        }
        if dataSource == nil{
            return;
        }
        var allWidth : CGFloat = 0
        for var index = 0 ; index < dataSource?.flashHorizontalViewCellCount(self) ; index++ {
            let view = UIButton(frame: CGRectMake(allWidth,0,frame.width,frame.height))
            self.dataSource!.flashHorizontalViewForCell(self, cell:view,index: index)
            view.addTarget(self, action: "btnOnClick:", forControlEvents: UIControlEvents.TouchUpInside)
            view.setTag(index+startTag)
            allWidth += view.frame.width
            self.addSubview(view)
        }
        self.contentSize = CGSizeMake(allWidth, frame.height)
        self.pagingEnabled=true
    }
    
    func btnOnClick( sender: UIButton){
        flashDelegate?.flashHorizontalViewDidSelectedCell(self, index: sender.tag()-startTag)
    }
    
    
    

}
