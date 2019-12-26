//
//  UIAOView.swift
//  HongMengPF
//
//  Created by 刘洪彬 on 2019/10/28.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAOView: UIView,UIAOFormControl {
    private var _vaild:UIAOFormVaild?
    private var _value:Any?
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
    
    var value: Any{
        set{ self._value = newValue}
        get{ return self._value}
    }
    
    var views = Dictionary<String,UIView>()
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
 
 
 

    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.white
    }
     */
    
    
}
