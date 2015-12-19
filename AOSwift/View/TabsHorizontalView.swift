//
//  TabsHorizontalView.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/16.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit
import AOCocoa

@objc protocol TabsHorizontalViewDataSource{
    func tabsHorizontalViewCellCount(tabsHorizontalView : TabsHorizontalView)->Int
    optional func tabsHorizontalViewCellWidth(tabsHorizontalView : TabsHorizontalView)->CGFloat
    optional func tabsHorizontalViewForCellSelectStyle(tabsHorizontalView : TabsHorizontalView, cell :UIButton,index: Int)
    optional func tabsHorizontalViewForCellUnSelectStyle(tabsHorizontalView : TabsHorizontalView, cell :UIButton,index: Int)
    func tabsHorizontalViewForCell(tabsHorizontalView : TabsHorizontalView,cell : UIButton,index: Int)
    optional func tabsHorizontalViewLineView(tabsHorizontalView : TabsHorizontalView)->UIView
}

@objc protocol TabsHorizontalViewDelegate{
    optional func tabsHorizontalViewDidSelectedCell(tabsHorizontalView : TabsHorizontalView,index: Int)
}


class TabsHorizontalView: UIScrollView {
    var lineView : UIView?
    var tabData :[Dictionary<String,String>] = []
    var allWith :CGFloat = 0
    var tabDelegate : TabsHorizontalViewDelegate?
    var dataSource : TabsHorizontalViewDataSource?
    
    var tagStart : Int{
        get{
            return 10100
        }
    }

    
    
    override func drawRect(rect: CGRect) {
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
    }
    
    func reload(){
        self.backgroundColor = UIColor.clearColor()
        self.clear()
        if self.dataSource == nil {
            return
        }
        var width :CGFloat = 0
        if let tmp = self.dataSource!.tabsHorizontalViewCellWidth?(self){
            width = tmp
        }
        
        for(var index = 0; index < self.dataSource!.tabsHorizontalViewCellCount(self) ; index++){
            let view = UIButton(frame: CGRectMake(allWith,0,width,frame.height))
            self.dataSource?.tabsHorizontalViewForCell(self, cell: view, index: index)
            view.setTag(tagStart+index)
            view.addTarget(self, action: "btnOnClick:", forControlEvents: UIControlEvents.TouchUpInside)
            allWith += view.frame.width
            self.addSubview(view);
        }
        self.contentSize=CGSizeMake(allWith, frame.height)
        lineView = self.dataSource!.tabsHorizontalViewLineView?(self)
        if lineView != nil{
            self.addSubview(lineView!)
            lineView!.hidden = true
        }
        if self.dataSource!.tabsHorizontalViewCellCount(self)>0{
            self.selectItem(0, isDelegateSelect: false)
        }
    }
    
    
    func clear(){
        allWith=0;
        for view in self.subviews{
            view.removeFromSuperview()
        }
        tabData.removeAll()
        
    }
    
    func btnOnClick(sender:UIButton){
        self.selectItem(sender.tag()-tagStart, isDelegateSelect: true)
    }
    
    func selectItem(index : Int, isDelegateSelect:Bool){
        for (var i=0;i<self.dataSource?.tabsHorizontalViewCellCount(self);i++){
            let item = self.viewWithTag(tagStart+i) as! UIButton
            if i==index {
                if lineView != nil {
                    lineView?.hidden=false
                    lineView?.center=CGPointMake(item.center.x, lineView!.center.y)
                }
                //滚动到中心位置
                self.dataSource?.tabsHorizontalViewForCellSelectStyle?(self,cell:item, index: i )
                self.setContentOffViewCenter(view: item)
            }else{
                self.dataSource?.tabsHorizontalViewForCellUnSelectStyle?(self,cell:item, index: i)
            }
        }
        if isDelegateSelect {
            tabDelegate?.tabsHorizontalViewDidSelectedCell?(self, index: index)
        }
        
    }

}
