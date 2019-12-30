//
//  UIAOButton.swift
//  RakubaiIOS
//
//  Created by 刘洪彬 on 2019/11/30.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class UIAOButton: UIButton,UIAOFormControl {
    let gradient: CAGradientLayer = CAGradientLayer()
    private var _vaild:UIAOFormVaild?
    var vaild:UIAOFormVaild?{
        set{ self._vaild = newValue}
        get{ return self._vaild}
    }
    private var _field = ""
   var field: String{
       set{ self._field = newValue}
       get{ return self._field}
       
   }
    private var _finish:((UIAOFormControl)->Void)?
    var finish:((UIAOFormControl)->Void)?{
        set{ self._finish = newValue}
        get{ return self._finish}
        
    }
    
    var views = Dictionary<String,UIView>()
    private var isOn = false
    private var isOnView:UIImageView?
    var onChange:((UIAOButton,Bool)->Bool)?
    var value:Any{
        set{
            isOn = newValue as? Int ?? 0>0
            self.onChange?(self,isOn)
            isOnView?.isHidden = !isOn
            self.convert?(newValue)
        }
        get{
            return isOn ? 1 : 0
        }
    }
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    var convert:((Any)->String)?
    
    func click(listener: @escaping () -> ()) {
        self.click(self, listener: listener)
    }
 
    func radio(text:String,height:CGFloat) {
        self.radio(text: text, height: height, size: 20)
    }
    
    func radio(text:String,height:CGFloat,size:CGFloat) {
        var margin = (height - size) * 0.5
        self.views = self.layoutHelper(name: "ico", h: "|-\(margin)-[?(\(size))]", v: "|-\(margin)-[?(\(size))]", views: self.views, delegate: { (v:UIImageView) in
            v.layer.cornerRadius = size * 0.5
            v.layer.masksToBounds = true
            v.layer.borderColor = AppDefault.DefaultBlue.cgColor
            v.layer.borderWidth = 1
            v.backgroundColor = .white
        })
        
        margin = (height - size*0.8) * 0.5
        self.views = self.layoutHelper(name: "ico_on", h: "|-\(margin)-[?(\(size*0.8))]", v: "|-\(margin)-[?(\(size*0.8))]", views: self.views, delegate: { (v:UIImageView) in
            v.layer.cornerRadius = size*0.8*0.5
            v.layer.masksToBounds = true
            v.backgroundColor = AppDefault.DefaultBlue
            isOnView = v
            isOnView?.isHidden = !isOn
        })
        
        self.views = self.layoutHelper(name: "text", h: "[ico]-10-[?]-0-|", v: "|-0-[?]-0-|", views: self.views, delegate: { (v:UILabel) in
            v.text = text
            v.textColor = AppDefault.DefaultGray
            v.font = UIFont.systemFont(ofSize: 14)
        })
        
        self.click(self) {
            self.change()
        }
    }
    
    func radio(height:CGFloat,size:CGFloat){
        var margin = (height - size) * 0.5
        self.views = self.layoutHelper(name: "ico", h: "|-\(margin)-[?(\(size))]", v: "|-\(margin)-[?(\(size))]", views: self.views, delegate: { (v:UIImageView) in
            v.layer.cornerRadius = size * 0.5
            v.layer.masksToBounds = true
            v.layer.borderColor = AppDefault.DefaultBlue.cgColor
            v.layer.borderWidth = 1
            v.backgroundColor = .white
        })
        
        margin = (height - size*0.8) * 0.5
        self.views = self.layoutHelper(name: "ico_on", h: "|-\(margin)-[?(\(size*0.8))]", v: "|-\(margin)-[?(\(size*0.8))]", views: self.views, delegate: { (v:UIImageView) in
            v.layer.cornerRadius = size*0.8*0.5
            v.layer.masksToBounds = true
            v.backgroundColor = AppDefault.DefaultBlue
            isOnView = v
            isOnView?.isHidden = !isOn
        })
    }
    
    func change(){
        if self.onChange?(self,!isOn) ?? true{
            isOn = !isOn
            isOnView?.isHidden = !isOn
        }
    }
    
    func applyGradient(_ colors: [UIColor], locations: [NSNumber]?) {
        gradient.colors = colors
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(gradient, at: 0)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }
}
