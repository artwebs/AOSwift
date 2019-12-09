//
//  UIAOTextView.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/9.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAOTextView: UITextView,UIAOFormControl {
    private var _field = ""
    var field: String{
        set{ self._field = newValue}
        get{ return self._field}
        
    }
    var views = Dictionary<String,UIView>()
    private var _listener = UIListener()
    override  var listener : UIListener{
       get{
           return _listener
       }
    }
    
    var value:Any{
        get{
            return self.text ?? ""
        }
    }
}
