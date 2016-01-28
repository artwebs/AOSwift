//
//  HeardView.swift
//  WebServer
//
//  Created by rsmac on 15/10/12.
//  Copyright © 2015年 artwebs. All rights reserved.
//

import UIKit

@objc protocol AOHeardViewDataSource{
    optional func heardViewForMiddleView(heardView : AOHeardView , size: CGSize)->UIView;
    optional func heardViewForLeftView(heardView : AOHeardView , size: CGSize)->UIView;
    optional func heardViewForRightView(heardView : AOHeardView , size: CGSize)->UIView;
}

protocol HeardViewDelegate{
    func onClickLeftBtn();
    func onClickRightBtn();
}

class AOHeardView : UIView {
    internal var leftView : UIView?
    internal var rightView : UIView?
    internal var middleView : UIView?
    var dataSource : AOHeardViewDataSource?
    internal var listeners = Dictionary<UIButton,()->()>()
    var viewController : UIViewController?
    
    
    
    func reload(){
        for view in self.subviews{
            view.removeFromSuperview()
        }
        
        self.leftView = dataSource?.heardViewForLeftView?(self, size: frame.size)
        self.rightView = dataSource?.heardViewForRightView?(self, size: frame.size)
        self.middleView = dataSource?.heardViewForMiddleView?(self, size: frame.size)
        
        if self.leftView != nil {
            self.leftView?.center = CGPoint(x: self.leftView!.center.x+10, y: (frame.height+20)*0.50)
            self.addSubview(self.leftView!)
        }
        
        if self.rightView != nil {
            self.rightView?.center = CGPoint(x: frame.width - self.rightView!.frame.width * 0.5-10, y: (frame.height+20)*0.50)
            self.addSubview(self.rightView!)
        }
        
        if self.middleView != nil {
            self.middleView?.center = CGPoint(x: frame.width * 0.5, y: (frame.height+20)*0.50)
            self.addSubview(self.middleView!)
        }
    }
    
    func setOnClick(sender : UIButton , listener: ()->()){
        sender.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        listeners[sender] = listener
    }
    
    func setBackViewController(sender : UIButton){
        setOnClick(sender) { [unowned self] in
            self.viewController?.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func setpushViewController(sender : UIButton , identifier : String){
        setOnClick(sender) { [unowned self] in
            self.viewController?.navigationController?.pushViewController(instantViewController(identifier), animated: true)
        }
    }
    
    internal  func onClick(sender : UIButton){
        if let listener = listeners[sender]{
            listener()
        }
    }
}

class AOHeardViewSimple: AOHeardView , AOHeardViewDataSource {
    
    func heardViewForLeftView(heardView: AOHeardView, size: CGSize) -> UIView {
        let view =  UIButton(frame: CGRectMake(0,0,size.width,size.height))
        return view
    }
    
    func heardViewForRightView(heardView: AOHeardView, size: CGSize) -> UIView {
        let view =  UIButton(frame: CGRectMake(0,0,size.width,size.height))
        return view
    }
    
    func heardViewForMiddleView(heardView: AOHeardView, size: CGSize) -> UIView {
        let view =  UILabel(frame: CGRectMake(0,0,size.width,size.height))
        view.textAlignment = NSTextAlignment.Center
        view.textColor = UIColor.blackColor()
        return view
    }
    
    func setTitle(title: String){
        if let view = self.middleView as? UILabel{
            view.text = title
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.dataSource = self
        self.reload()
    }
    
    override func reload() {
        self.dataSource = self
        super.reload()
    }

}


