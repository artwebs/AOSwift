//
//  PagesHorizontalView.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/19.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit


protocol PagesHorizontalViewDataSource{
    func pagesHorizontalViewCellCount(pagesHorizontalView : PagesHorizontalView)->Int
    func pagesHorizontalViewForCell(pagesHorizontalView : PagesHorizontalView,cell : UIView,index: Int)
}

protocol PagesHorizontalViewDelegate{
    func pagesHorizontalViewDidSelectedCell(pagesHorizontalView : PagesHorizontalView,index: Int)
}

class PagesHorizontalView: UIScrollView,UIScrollViewDelegate {
    var dataSource : PagesHorizontalViewDataSource?
    var pageDelegate : PagesHorizontalViewDelegate?
    
    var startContentOffsetX : CGFloat = 0
    var endContentOffsetX : CGFloat = 0
    private var selectIndex = 0
    
    var startTag : Int{
        get{
            return 10200
        }
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func drawRect(rect: CGRect) {
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
        self.delegate = self
    }

    
    func reload(){
        self.backgroundColor = UIColor.clearColor()
        for view in self.subviews{
            view.removeFromSuperview()
        }
        if dataSource == nil{
            return ;
        }
        
        var allWidth : CGFloat = 0
        for var index = 0 ; index < dataSource?.pagesHorizontalViewCellCount(self) ; index++ {
            let view = UIView(frame: CGRectMake(allWidth,0,frame.width,frame.height))
            self.dataSource!.pagesHorizontalViewForCell(self, cell:view,index: index)
            view.setTag(index+startTag)
            allWidth += view.frame.width
            self.addSubview(view)
        }
        self.contentSize = CGSizeMake(allWidth, frame.height)
        self.pagingEnabled=true
        if dataSource?.pagesHorizontalViewCellCount(self)>0{
            selectItem(0, isDelegateSelect: false)
        }
    }
    
    func selectItem(index : Int, isDelegateSelect:Bool){
        selectIndex = index
        if let item = self.viewWithTag(startTag+index){
            self.setContentOffViewCenter(view: item)
            if !isDelegateSelect {
                self.pageDelegate?.pagesHorizontalViewDidSelectedCell(self, index: index)
            }
        }
        
    }
    
    //MARK --- UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        startContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        endContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if dataSource?.pagesHorizontalViewCellCount(self)  == 0 {
            return
        }
        if (endContentOffsetX - startContentOffsetX > 0 ){
            if selectIndex < (dataSource?.pagesHorizontalViewCellCount(self))! - 1{
                self.pageDelegate?.pagesHorizontalViewDidSelectedCell(self, index: ++selectIndex)
            }
        }else{
            if selectIndex > 0 {
                self.pageDelegate?.pagesHorizontalViewDidSelectedCell(self, index: --selectIndex)
            }
        }
    }
    

}
