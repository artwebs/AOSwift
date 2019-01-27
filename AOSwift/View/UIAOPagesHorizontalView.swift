//
//  PagesHorizontalView.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/19.
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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



protocol UIAOPagesHorizontalViewDataSource{
    func pagesHorizontalViewCellCount(_ pagesHorizontalView : UIAOPagesHorizontalView)->Int
    func pagesHorizontalViewForCell(_ pagesHorizontalView : UIAOPagesHorizontalView,cell : UIView,index: Int)
}

protocol UIAOPagesHorizontalViewDelegate{
    func pagesHorizontalViewDidSelectedCell(_ pagesHorizontalView : UIAOPagesHorizontalView,index: Int)
}

class UIAOPagesHorizontalView: UIScrollView,UIScrollViewDelegate {
    var dataSource : UIAOPagesHorizontalViewDataSource?
    var pageDelegate : UIAOPagesHorizontalViewDelegate?
    
    var startContentOffsetX : CGFloat = 0
    var endContentOffsetX : CGFloat = 0
    fileprivate var selectIndex = 0
    
    var startTag : Int{
        get{
            return 10200
        }
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func draw(_ rect: CGRect) {
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
        self.delegate = self
    }

    
    func reload(){
        self.backgroundColor = UIColor.clear
        for view in self.subviews{
            view.removeFromSuperview()
        }
        if dataSource == nil{
            return ;
        }
        
        var allWidth : CGFloat = 0
        if let count = dataSource?.pagesHorizontalViewCellCount(self){
            for index in 0 ..< count {
                let view = UIView(frame: CGRect(x: allWidth,y: 0,width: frame.width,height: frame.height))
                self.dataSource!.pagesHorizontalViewForCell(self, cell:view,index: index)
                view.setTag(index+startTag)
                allWidth += view.frame.width
                self.addSubview(view)
            }
        }
        
        self.contentSize = CGSize(width: allWidth, height: frame.height)
        self.isPagingEnabled=true
        if dataSource?.pagesHorizontalViewCellCount(self)>0{
            selectItem(0, isDelegateSelect: false)
        }
    }
    
    func selectItem(_ index : Int, isDelegateSelect:Bool){
        selectIndex = index
        if let item = self.viewWithTag(startTag+index){
            self.setContentOffViewCenter(view: item)
            if !isDelegateSelect {
                self.pageDelegate?.pagesHorizontalViewDidSelectedCell(self, index: index)
            }
        }
        
    }
    
    //MARK --- UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        endContentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if dataSource?.pagesHorizontalViewCellCount(self)  == 0 {
            return
        }
        if (endContentOffsetX - startContentOffsetX > 0 ){
            if selectIndex < (dataSource?.pagesHorizontalViewCellCount(self))! - 1{
                selectIndex+=1;
                self.pageDelegate?.pagesHorizontalViewDidSelectedCell(self, index: selectIndex)
            }
        }else{
            if selectIndex > 0 {
                selectIndex-=1;
                self.pageDelegate?.pagesHorizontalViewDidSelectedCell(self, index: selectIndex)
            }
        }
    }
    

}
