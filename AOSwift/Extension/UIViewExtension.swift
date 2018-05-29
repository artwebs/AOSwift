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
    
    func click(_ sender : UIButton , listener: @escaping ()->()){
        sender.addTarget(self, action: #selector(UIView.onClick(_:)), for: UIControlEvents.touchUpInside)
        self.listener.set(view:sender,listener:listener)
    }
    
    @objc internal  func onClick(_ sender : UIButton){
        self.listener.get(view: sender)?()
    }
}
