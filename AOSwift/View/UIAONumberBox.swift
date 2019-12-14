//
//  UIAONumberBox.swift
//  RakubaiIOS
//
//  Created by 刘洪彬 on 2019/11/30.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class UIAONumberBox: UIAOView,UIAOFormControl {
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
    
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    
    var textField:UITextField?
    var onChange:((UIAOFormControl)->Void)?
    private var min:Int = 0
    var value:Any{
        set{
            self.textField?.text = newValue as? String ?? "0"
        }
        get{
            return self.textField?.text ?? "0"
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
                 self.onChange?(self)
            })
        })
        
        self.views = self.layoutHelper(name: "text", h: "[left]-0-[?]-0-[right]", v: "|-0-[?]-0-|", views: self.views, delegate: { (v:UITextField) in
            v.font = UIFont.systemFont(ofSize: 14)
            v.textColor = AppDefault.DefaultGray
            v.text = "0"
            v.textAlignment = .center
            self.textField = v
        })
    }
    
    func change(v:Int){
        let val = self.textField?.text ?? "0"
        if Int(val)! + v < 0{
            return
        }
        self.textField?.text = "\(Int(val)!+v)"
    }
    
    
    


}
