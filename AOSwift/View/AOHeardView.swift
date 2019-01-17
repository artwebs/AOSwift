//
//  HeardView.swift
//  WebServer
//
//  Created by rsmac on 15/10/12.
//  Copyright © 2015年 artwebs. All rights reserved.
//

import UIKit

@objc protocol AOHeardViewDataSource{
    @objc optional func heardViewForMiddleView(_ heardView : AOHeardView , size: CGSize)->UIView;
    @objc optional func heardViewForLeftView(_ heardView : AOHeardView , size: CGSize)->UIView;
    @objc optional func heardViewForRightView(_ heardView : AOHeardView , size: CGSize)->UIView;
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
    var viewController : UIViewController?
    fileprivate var viewHidden = [false,false,false]
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    
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
            self.leftView?.isHidden = viewHidden[0]
        }
        
        if self.rightView != nil {
            self.rightView?.center = CGPoint(x: frame.width - self.rightView!.frame.width * 0.5-10, y: (frame.height+20)*0.50)
            self.addSubview(self.rightView!)
            self.rightView?.isHidden = viewHidden[2]
        }
        
        if self.middleView != nil {
            self.middleView?.center = CGPoint(x: frame.width * 0.5, y: (frame.height+20)*0.50)
            self.addSubview(self.middleView!)
            self.middleView?.isHidden = viewHidden[1]
        }
    }
    
    func setViewHidden(_ left:Bool,middle:Bool,right:Bool){
        viewHidden[0] = left
        viewHidden[1] = middle
        viewHidden[2] = right
        
        self.leftView?.isHidden = viewHidden[0]
        self.rightView?.isHidden = viewHidden[2]
        self.middleView?.isHidden = viewHidden[1]
    }
    
   
    
    func setBackViewController(_ sender : UIButton){
        click(sender) { [unowned self] in
            self.vController?.navigationController?.popViewController(animated: true)
        }
    }
    
    func setpushViewController(_ sender : UIButton , identifier : String){
        click(sender) { [unowned self] in
            self.vController?.navigationController?.pushViewController(instantViewController(identifier), animated: true)
        }
    }
    
    
}

class AOHeardViewSimple: AOHeardView , AOHeardViewDataSource {
    fileprivate var titleText : String?
    
    func heardViewForLeftView(_ heardView: AOHeardView, size: CGSize) -> UIView {
        let view =  UIButton(frame: CGRect(x: 0,y: 0,width: size.width,height: size.height))
        return view
    }
    
    func heardViewForRightView(_ heardView: AOHeardView, size: CGSize) -> UIView {
        let view =  UIButton(frame: CGRect(x: 0,y: 0,width: size.width,height: size.height))
        return view
    }
    
    func heardViewForMiddleView(_ heardView: AOHeardView, size: CGSize) -> UIView {
        let view =  UILabel(frame: CGRect(x: 0,y: 0,width: size.width,height: size.height))
        view.textAlignment = NSTextAlignment.center
        view.textColor = UIColor.black
        return view
    }
    
    func setTitle(_ title: String){
        titleText = title
        reloadTitle()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.dataSource = self
        self.reload()
    }
    
    override func reload() {
        self.dataSource = self
        super.reload()
        reloadTitle()
    }
    
    fileprivate func reloadTitle(){
        if let view = self.middleView as? UILabel{
            view.text = titleText
        }
    }

}


