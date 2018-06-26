//
//  UIView.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/19.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit
var AOSwiftViewID = 10000

extension UIView{
    var listener : UIListener{
        get{
            return UIListener()
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
    
    func layoutInit<T:UIView>(name:String,delegate:(T)->Void)->Dictionary<String,UIView>{
        return self.layoutInit(name: name, views: self.initViews(), delegate: delegate)
    }
    
    func layoutInit<T:UIView>(name:String,views:Dictionary<String,UIView>,delegate:(T)->Void)->Dictionary<String,UIView>{
        let view = T()
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
        delegate(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        var _views = views
        _views[name] = view
        return _views
    }
    
    func layoutDraw(views:Dictionary<String,UIView>,layout:String...)  {
        for lay in layout {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: lay, options: [], metrics: nil, views: views))
        }
    }
    
    func layoutHelper<T:UIView>(name:String,h:String,v:String,views:Dictionary<String,UIView>,delegate:(T)->Void)->Dictionary<String,UIView>{
        let _views=self.layoutInit(name: name, views: views, delegate: delegate)
        layoutDraw(views: _views, layout: h.replacingOccurrences(of: "?", with: name),v.replacingOccurrences(of: "?", with: name))
        return _views
    }
    
}


