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
    
    struct PullToRefreshConst {
        static let tag = 810
        static let alpha = true
        static let height: CGFloat = 80
        static let imageName: String = "pulltorefresharrow.png"
        static let animationDuration: Double = 0.4
        static let fixedTop = true // PullToRefreshView fixed Top
    }
    
    class PullToRefreshOption {
        var backgroundColor = UIColor.clear
        var indicatorColor = UIColor.gray
        var autoStopTime: Double = 0.7 // 0 is not auto stop
        var fixedSectionHeader = false  // Update the content inset for fixed section headers
    }
    
//    fileprivate var pullToRefreshView: PullToRefreshView? {
//        get {
//            let pullToRefreshView = viewWithTag(PullToRefreshConst.tag)
//            return pullToRefreshView as? PullToRefreshView
//        }
//    }
//    
//    func addPullToRefresh(_ refreshCompletion :@escaping (() -> ())) {
//        self.addPullToRefresh(PullToRefreshOption(), refreshCompletion: refreshCompletion)
//    }
//    
//    func addPullToRefresh(_ options: PullToRefreshOption = PullToRefreshOption(), refreshCompletion :@escaping (() -> ())) {
//        let refreshViewFrame = CGRect(x: 0, y: -PullToRefreshConst.height, width: self.frame.size.width, height: PullToRefreshConst.height)
//        let refreshView = PullToRefreshView(options: options, frame: refreshViewFrame, refreshCompletion: refreshCompletion)
//        refreshView.setTag(PullToRefreshConst.tag)
//        addSubview(refreshView)
//    }
//    
//    func startPullToRefresh() {
//        pullToRefreshView?.state = .refreshing
//    }
//    
//    func stopPullToRefresh() {
//        pullToRefreshView?.state = .normal
//    }
//    
//    // If you want to PullToRefreshView fixed top potision, Please call this function in scrollViewDidScroll
//    func fixedPullToRefreshViewForDidScroll() {
//        if PullToRefreshConst.fixedTop {
//            if self.contentOffset.y < -PullToRefreshConst.height {
//                if var frame = pullToRefreshView?.frame {
//                    frame.origin.y = self.contentOffset.y
//                    pullToRefreshView?.frame = frame
//                }
//            } else {
//                if var frame = pullToRefreshView?.frame {
//                    frame.origin.y = -PullToRefreshConst.height
//                    pullToRefreshView?.frame = frame
//                }
//            }
//        }
//    }
    
}
