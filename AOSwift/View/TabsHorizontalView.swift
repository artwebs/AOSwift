//
//  TabsHorizontalView.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/16.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit
import AOCocoa

protocol TabsHorizontalViewDataSource{
    func selectItem(tabsHorizontalView tabsHorizontalView : TabsHorizontalView,index : Int ,data : Dictionary<String,String>)
}


protocol TabsHorizontalViewDelegate{
    func selectItem(tabsHorizontalView tabsHorizontalView : TabsHorizontalView,index : Int ,data : Dictionary<String,String>)
}


class TabsHorizontalView: UIScrollView {
    let lineView : UIView = UIView()
    var tabs :[UIButton]=[]
    var tabData :[Dictionary<String,String>] = []
    var tagStart=1000;
    var allWith :CGFloat = 0
    var tabDelegate : TabsHorizontalViewDelegate?

    
    
    override func drawRect(rect: CGRect) {
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
    }
    
    
    func show(data:[Dictionary<String,String>]){
        self.clear()
        tabData += data
        
        for (index , value ) in tabData.enumerate(){
            let btn = initTabItem(index,item: value)
            tabs.append(btn)
            self.addSubview(btn);
        }
        self.contentSize=CGSizeMake(allWith, frame.height)
        initLineView(frame);
        self.addSubview(lineView)
        self.backgroundColor=UIColor.clearColor()
        self.selectItem(0, isDelegateSelect: false)
    }
    
    func clear(){
        allWith=0;
        for view in self.subviews{
            view.removeFromSuperview()
        }
        tabs.removeAll()
        tabData.removeAll()
        
    }
    
    func initTabItem(index : Int,item : Dictionary<String,String>)->UIButton{
        let btn = UIButton()
        if let text = item["title"]{
            let fontSize = Utils.stringLength(text, fontSize: Float(UIFont.buttonFontSize()))
            btn.frame = CGRectMake(allWith, 0, fontSize.width+16, frame.height)
            btn.setTitle(text, forState: UIControlState.Normal)
            
        }
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignment.Center
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: "btnOnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.setTag(index+tagStart)
        allWith += btn.frame.width
        return btn;
    }
    
    func initLineView(rect:CGRect){
        
    }
    
    func btnOnClick(sender:UIButton){
        self.selectItem(sender.tag()-tagStart, isDelegateSelect: true)
    }
    
    func selectItem(index : Int, isDelegateSelect:Bool){
        for (i,item) in tabs.enumerate(){
            if i==index {
                lineView.hidden=false
                lineView.center=CGPointMake(item.center.x, lineView.center.y)
                //滚动到中心位置
                self.setContentOffViewCenter(view: item)
            }else{
                item.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            }
        }
        if isDelegateSelect {
            tabDelegate?.selectItem(tabsHorizontalView:self,index:index,data:tabData[index])
        }
        
    }

}
