//
//  UIAOTabsView.swift
//  RakubaiIOS
//
//  Created by 刘洪彬 on 2019/11/6.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit
import AOCocoa
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



@objc protocol UIAOTabsViewDataSource{
    func tabsViewCellCount(_ tabsView : UIAOTabsView)->Int
    @objc optional func tabsViewCellSize()->CGSize
    @objc optional func tabsViewForCellSelectStyle(_ tabsView : UIAOTabsView, cell :UIButton,index: Int)
    @objc optional func tabsViewForCellUnSelectStyle(_ tabsView : UIAOTabsView, cell :UIButton,index: Int)
    func tabsViewForCell(_ tabsView : UIAOTabsView,cell : UIButton,index: Int)
    @objc optional func tabsViewLineView(_ tabsView : UIAOTabsView)->UIView
}

@objc protocol UIAOTabsViewDelegate{
    @objc optional func tabsViewDidSelectedCell(_ tabsView : UIAOTabsView,index: Int)
}

class UIAOTabsView: UIAOScrollView {
    var lineView : UIView?
    var tabData :[Dictionary<String,String>] = []
    var allWith :CGFloat = 0
    var allHeight :CGFloat = 0
    var tabDelegate : UIAOTabsViewDelegate?
    var dataSource : UIAOTabsViewDataSource?
    var type:UIScrollViewType = .horizontal
    
    var tagStart : Int{
        get{
            return 10100
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
    }
    
    func reload(didSelected sindex:Int){
        self.reload(didSelected: sindex, isDelegateSelect: false)
    }
    
    func reload(didSelected sindex:Int,isDelegateSelect:Bool){
        self.backgroundColor = UIColor.clear
        self.clear()
        if self.dataSource == nil {
            return
        }
        var width :CGFloat = 0
        var height:CGFloat = 0
        if type == .horizontal{
            height = frame.height
            width = self.frame.width / (CGFloat((self.dataSource!.tabsViewCellCount(self))))
        }else{
            height = 44
            width = self.frame.width
        }
        if let size = self.dataSource?.tabsViewCellSize?(){
            width = size.width
            height = size.height
        }
        
        for index in 0 ..< self.dataSource!.tabsViewCellCount(self){
            let view = UIButton(frame: CGRect(x: allWith,y: allHeight,width: width,height: height))
            self.dataSource?.tabsViewForCell(self, cell: view, index: index)
            view.setTag(tagStart+index)
            view.addTarget(self, action: #selector(UIAOTabsView.btnOnClick(_:)), for: UIControl.Event.touchUpInside)
            if type == .horizontal{
                allWith += view.frame.width
            }else{
                allHeight += height
            }
            self.addSubview(view);
        }
        self.contentSize=CGSize(width: allWith, height: allHeight)
        lineView = self.dataSource!.tabsViewLineView?(self)
        if lineView != nil{
            self.addSubview(lineView!)
            lineView!.isHidden = true
        }
        if self.dataSource!.tabsViewCellCount(self)>0{
            self.selectItem(sindex, isDelegateSelect: isDelegateSelect)
        }
    }
    
    
    
    func clear(){
        allWith=0;
        allHeight=0;
        for view in self.subviews{
            view.removeFromSuperview()
        }
        tabData.removeAll()
        
    }
    
    @objc func btnOnClick(_ sender:UIButton){
        self.selectItem(sender.tag()-tagStart, isDelegateSelect: true)
    }
    
    func selectItem(_ index : Int, isDelegateSelect:Bool){
        if let count = self.dataSource?.tabsViewCellCount(self){
            for i in 0 ..< count{
                let item = self.viewWithTag(tagStart+i) as! UIButton
                if i==index {
                    if lineView != nil {
                        lineView?.isHidden=false
                        lineView?.center=CGPoint(x: item.center.x, y: lineView!.center.y)
                    }
                    //滚动到中心位置
                    self.dataSource?.tabsViewForCellSelectStyle?(self,cell:item, index: i )
                    self.setContentOffViewCenter(view: item,type: self.type)
                }else{
                    self.dataSource?.tabsViewForCellUnSelectStyle?(self,cell:item, index: i)
                }
            }
        }
        
        if isDelegateSelect {
            tabDelegate?.tabsViewDidSelectedCell?(self, index: index)
        }
        
    }
    

}
