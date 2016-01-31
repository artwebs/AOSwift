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
    var vController : UIViewController?{
        get{
            return nil
        }
        set{}
    }
    
    class func translatesAutoresizingMaskIntoConstraintsFalse(views : Dictionary<String,UIView>){
        for (_ , view) in views{
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
