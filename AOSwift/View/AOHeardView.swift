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
    private var viewHidden = [false,false,false]
    
    
    
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
            self.leftView?.hidden = viewHidden[0]
        }
        
        if self.rightView != nil {
            self.rightView?.center = CGPoint(x: frame.width - self.rightView!.frame.width * 0.5-10, y: (frame.height+20)*0.50)
            self.addSubview(self.rightView!)
            self.rightView?.hidden = viewHidden[2]
        }
        
        if self.middleView != nil {
            self.middleView?.center = CGPoint(x: frame.width * 0.5, y: (frame.height+20)*0.50)
            self.addSubview(self.middleView!)
            self.middleView?.hidden = viewHidden[1]
        }
    }
    
    func setViewHidden(left:Bool,middle:Bool,right:Bool){
        viewHidden[0] = left
        viewHidden[1] = middle
        viewHidden[2] = right
        
        self.leftView?.hidden = viewHidden[0]
        self.rightView?.hidden = viewHidden[2]
        self.middleView?.hidden = viewHidden[1]
    }
    
    func setOnClick(sender : UIButton , listener: ()->()){
        sender.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        listeners[sender] = listener
    }
    
    func setBackViewController(sender : UIButton){
        setOnClick(sender) { [unowned self] in
            self.viewController?.navigationController?.popViewControllerAnimated(true)
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
    private var titleText : String?
    
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
        titleText = title
        reloadTitle()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.dataSource = self
        self.reload()
    }
    
    override func reload() {
        self.dataSource = self
        super.reload()
        reloadTitle()
    }
    
    private func reloadTitle(){
        if let view = self.middleView as? UILabel{
            view.text = titleText
        }
    }

}


