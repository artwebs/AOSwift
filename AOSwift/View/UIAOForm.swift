//
//  UIAOForm.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/9.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

struct UIAOFormVaild {
    var regex:String
    var msg:String
}

protocol UIAOFormControl{
    var vaild:UIAOFormVaild?{
        set
        get
    }
    var finish:((UIAOFormControl)->Void)?{
        set
        get
    }
    var field:String{
        set
        get
    }
    var value:Any{
        set
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
    
    class func valueSet(view:UIView,param:[String:Any]){
        for vview in view.subviews{
            if var ctl = vview as? UIAOFormControl,ctl.field != ""{
                ctl.value = param[ctl.field]
            }
            if vview.subviews.count > 0{
                UIAOForm.valueSet(view: vview, param: param)
            }
        }
    }
    
    class func valueVaild(view:UIView,param: inout [String:Any],success:([String:Any])->Void,fail:(String)->Void){
        for vview in view.subviews{
            if let ctl = vview as? UIAOFormControl,ctl.field != ""{
                if let vaild = ctl.vaild {
                    if !UtilHelper.regex(pattern: vaild.regex, str: "\(ctl.value)"){
                        fail(vaild.msg)
                        return
                    }
                }
                param[ctl.field] = ctl.value
            }
            if vview.subviews.count > 0{
                UIAOForm.valueVaild(view: vview, param: &param,success: success,fail: fail)
            }
        }
        success(param)
    }
    
    class func valueVaild(view:UIView,param: inout [String:Any],success:([String:Any])->Void){
        UIAOForm.valueVaild(view: view, param: &param, success: success,fail: {(msg) in 
            AOSwift.alert(message: msg, handler: nil)
        })
    }
}
