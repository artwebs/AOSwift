//
//  UIAOForm.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/9.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

protocol UIAOFormControl{
    var field:String{
        set
        get
    }
    var value:Any{
        get
    }
}

class UIAOForm: UIAOView {
    class func valueFor(view:UIView,param: inout [String:Any]){
        for vview in view.subviews{
            if let ctl = vview as? UIAOFormControl,ctl.field != ""{
                param[ctl.field] = ctl.value
            }
            if vview.subviews.count > 0{
                UIAOForm.valueFor(view: vview, param: &param)
            }
        }
    }
    
}
