//
//  UIView.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/19.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit
var AOSwiftViewID = 10000
private var AOSwiftViews=Dictionary<String,Dictionary<String,UIView>>()
extension UIView{
    var listener : UIListener{
        get{
            return UIListener()
        }
    }
    
    var views : Dictionary<String,UIView>{
        get{
            return Dictionary<String,UIView>()
        }
    }
    
    
    var vController : UIViewController?{
        get{
            for view in sequence(first: self.superview, next: { $0?.superview }) {
                if let responder = view?.next {
                    if responder.isKind(of: UIViewController.self){
                        return responder as? UIViewController
                    }
                }
            }
            return nil
        }
    }
    
    class func translatesAutoresizingMaskIntoConstraintsFalse(_ views : Dictionary<String,UIView>){
        for (_ , view) in views{
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func initSubView<T:UIView>(name:String,h:String,v:String) -> T {
        let view = T()
        self.addSubview(view)
        var views = self.views
        views[name] = view
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: h.replacingOccurrences(of: "?", with: name), options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: v.replacingOccurrences(of: "?", with: name), options: [], metrics: nil, views: views))
        return view
    }
    
    func initViews()->Dictionary<String,UIView>{
        return Dictionary<String,UIView>();
    }
    
    func click(_ sender : UIButton , listener: @escaping ()->()){
        sender.addTarget(self, action: #selector(UIView.onClick(_:)), for: UIControlEvents.touchUpInside)
        self.listener.set(view:sender,listener:listener)
    }
    
    @objc internal  func onClick(_ sender : UIButton){
        self.listener.get(view: sender)?()
    }
    
}
