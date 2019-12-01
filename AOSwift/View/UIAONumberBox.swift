//
//  UIAONumberBox.swift
//  RakubaiIOS
//
//  Created by 刘洪彬 on 2019/11/30.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class UIAONumberBox: UIAOView {
    private var text:UITextField?
    private var min:Int = 0
    var value:String{
        set{
            self.text?.text = newValue
        }
        get{
            return self.text?.text ?? "0"
        }
    }
    
    func load(){
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.layer.borderColor = AppDefault.DefaultGray.cgColor
        self.layer.borderWidth = 1
        self.views = self.layoutHelper(name: "left", h: "|-4-[?(30)]", v: "|-0-[?]-0-|", views: self.views, delegate: { (v:UIButton) in
            v.setTitle("-", for: .normal)
            v.setTitleColor(AppDefault.DefaultGray, for: .normal)
            v.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            self.click(v, listener: {
                self.change(v: -1)
            })
        })
        
        self.views = self.layoutHelper(name: "right", h: "[?(30)]-4-|", v: "|-0-[?]-0-|", views: self.views, delegate: { (v:UIButton) in
            v.setTitle("+", for: .normal)
            v.setTitleColor(AppDefault.DefaultGray, for: .normal)
            v.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            self.click(v, listener: {
                 self.change(v: 1)
            })
        })
        
        self.views = self.layoutHelper(name: "text", h: "[left]-0-[?]-0-[right]", v: "|-0-[?]-0-|", views: self.views, delegate: { (v:UITextField) in
            v.font = UIFont.systemFont(ofSize: 14)
            v.textColor = AppDefault.DefaultGray
            v.text = "0"
            self.text = v
        })
    }
    
    func change(v:Int){
        let val = self.text?.text ?? "0"
        if Int(val)! + v < 0{
            return
        }
        self.text?.text = "\(Int(val)!+v)"
    }
    


}
