//
//  UIView.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/19.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit
import AOCocoa
var AOSwiftViewID = 10000

extension UIView{
    
    
    @objc var listener : UIListener{
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
        sender.addTarget(self, action: #selector(UIView.onClick(_:)), for: UIControl.Event.touchUpInside)
        self.listener.set(view:sender,listener:listener)
    }
    
    @objc internal  func onClick(_ sender : UIButton){
        self.listener.get(view: sender)?()
    }
    
    func layoutInit<T:UIView>(name:String,delegate:(T)->Void)->Dictionary<String,UIView>{
        return self.layoutInit(name: name, views: self.initViews(), delegate: delegate)
    }
    
    func layoutInit<T:UIView>(name:String,views:Dictionary<String,UIView>,delegate:(T)->Void)->Dictionary<String,UIView>{
        var _views = views
        let view = T()
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
        delegate(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        _views[name] = view
        return _views
    }
    
    func layoutDraw(views:Dictionary<String,UIView>,layout:String...)  {
        for lay in layout {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: lay, options: [], metrics: nil, views: views))
        }
    }
    
    func layoutHelper<T:UIView>(name:String,h:String,v:String,delegate:(T)->Void)->Dictionary<String,UIView>{
       return layoutHelper(name: name, h: h, v: v, views: self.initViews() , delegate: delegate)
       
    }
    
    func layoutHelper<T:UIView>(name:String,h:String,v:String, views: Dictionary<String,UIView>,delegate:(T)->Void)->Dictionary<String,UIView>{
        var _views = views
        var _h = h
        var _v = v
        if(!_h.hasPrefix("H:")) {
            _h = "H:" + _h;
        }
        if(!v.hasPrefix("V:")) {
            _v = "V:" + _v;
        }
        if let view = _views[name] as? T{
            delegate(view)
        }else{
            _views=self.layoutInit(name: name, views: views, delegate: delegate)
            layoutDraw(views: _views, layout: _h.replacingOccurrences(of: "?", with: name),_v.replacingOccurrences(of: "?", with: name))
        }
        return _views;
        
    }
    
    func line(){
        self.layoutHelper(name: "line", h: "|-0-[?]-0-|", v: "[?(2)]-0-|") { (v:UIImageView) in
            v.image = Utils.createImage(with: AppDefault.DefaultLightGray)
        }
    }
    
    func color(startColor:UIColor,endColor:UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        gradientLayer.colors = [startColor,endColor]
        let gradientLocations:[NSNumber] = [0.0,1.0]
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        self.layer.addSublayer(gradientLayer)
    }
    
}


