//
//  UIAOButton.swift
//  RakubaiIOS
//
//  Created by 刘洪彬 on 2019/11/30.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class UIAOButton: UIButton {
    var views = Dictionary<String,UIView>()
    private var isOn = false
    private var isOnView:UIImageView?
    var onChange:((UIAOButton,Bool)->Bool)?
    var value:Int{
        set{
            isOn = newValue>0
            isOnView?.isHidden = !isOn
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
    
    
    private func change(){
        if self.onChange?(self,!isOn) ?? true{
            isOn = !isOn
            isOnView?.isHidden = !isOn
        }
    }
    

}
