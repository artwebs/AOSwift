//
//  HeardView.swift
//  WebServer
//
//  Created by rsmac on 15/10/12.
//  Copyright © 2015年 artwebs. All rights reserved.
//

import UIKit

@objc protocol AOHeardViewDataSource{
    optional func heardViewForMiddleView(hearView : AOHeardView , size: CGSize)->UIView;
    optional func heardViewForLeftView(hearView : AOHeardView , size: CGSize)->UIView;
    optional func heardViewForRightView(hearView : AOHeardView , size: CGSize)->UIView;
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
            self.leftView?.center = CGPoint(x: self.leftView!.center.x, y: (frame.height+20)*0.50)
            self.addSubview(self.leftView!)
        }
        
        if self.rightView != nil {
            self.rightView?.center = CGPoint(x: frame.width - self.rightView!.frame.width * 0.5, y: (frame.height+20)*0.50)
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
    
    private  func onClick(sender : UIButton){
        if let listener = listeners[sender]{
            listener()
        }
    }
}

class AOHeardViewSimple: AOHeardView , AOHeardViewDataSource {
    
    func heardViewForLeftView(hearView: AOHeardView, size: CGSize) -> UIView {
        let view =  UIButton(frame: CGRectMake(0,0,size.width,size.height))
        return view
    }
    
    func heardViewForRightView(hearView: AOHeardView, size: CGSize) -> UIView {
        let view =  UIButton(frame: CGRectMake(0,0,size.width,size.height))
        return view
    }
    
    func heardViewForMiddleView(hearView: AOHeardView, size: CGSize) -> UIView {
        let view =  UILabel(frame: CGRectMake(0,0,size.width,size.height))
        view.textAlignment = NSTextAlignment.Center
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
        
        
        
//        self.backgroundColor = AppDefault.ColorBlue
//        leftBtn = UIButton(frame: CGRectMake(10, 20, 40, 40))
//        leftBtn?.center = CGPointMake((leftBtn?.center.x )!, (rect.height+20)*0.5)
//        
//        self.addSubview(leftBtn!)
//        
//        centerView  = UIView(frame: CGRectMake(0, 20, rect.width-100, 30))
//        centerView?.center = CGPointMake(rect.width*0.5, (rect.height+20)*0.50)
//        self.addSubview(centerView!)
//        
//        rightBtn = UIButton(frame: CGRectMake(rect.width-64, 20, 44, 44))
//        rightBtn?.center = CGPointMake((rightBtn?.center.x )!, (rect.height+20)*0.5)
//        self.addSubview(rightBtn!)
        
    }
    
    override func reload() {
        super.reload()
        if let view  = self.leftView as? UIButton{
            let listener = listeners[view]
            if listener == nil {
                setBackViewController(view)
            }
        }
    }
//    
//    func initTitleLayout(title :String ){
//        if let rect = centerView?.frame {
//            titleLabel = UILabel(frame: CGRectMake(0, 0, rect.width, rect.height))
//            titleLabel?.textColor = UIColor.whiteColor()
//            titleLabel?.text = title
//            titleLabel?.textAlignment = NSTextAlignment.Center
//            titleLabel?.center = CGPointMake(rect.width*0.5, rect.height*0.50)
//            centerView?.addSubview(titleLabel!)
//        }
//        
//    }
//    
//    
//    func initImageBtnLayout(){
//        
//    }
//    
//    func initOtherLayout(view : UIView){
//        
//    }
//    
//    func initDefault(){
////        leftBtn?.setImage(UIImage(named: "ico_in"), forState: UIControlState.Normal)
//        titleLabel?.text = "Web Server"
//        
//    }
//    
//    func setBack(controller : UIViewController){
//        viewController = controller
//        leftBtn?.setTag(1000);
////        leftBtn?.setImage(UIImage(named: "ico_back"), forState: UIControlState.Normal)
//        leftBtn?.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
//    }
//    
//    func setSetting(controller :  UIViewController){
//        viewController = controller
////        rightBtn?.setImage(UIImage(named: "ico_setting"), forState: UIControlState.Normal);
//        rightBtn?.setTag(1001)
//        rightBtn?.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
//    }
//    
//    
//    func onClick(sender : UIButton){
//        switch(sender.tag()){
//        case 1000:
//            delegate?.onClickLeftBtn()
////            viewController?.navigationController?.popToRootViewControllerAnimated(true)
//            break;
//        case 1001:
//            delegate?.onClickRightBtn()
////          viewController?.navigationController?.pushViewController((viewController?.storyboard?.instantiateViewControllerWithIdentifier(SettingViewController.identifier))!, animated: true)
//            break;
//        default:
//            break;
//        }
//    }

}


