//
//  UIAODateField.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/17.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAODateField: UIAOTextField {
    var selectView:UIAODateView?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    
    func toSelect(size:CGSize){
        self.selectView=UIAODateView(frame:UIScreen.main.bounds, width:size.width , height:size.height)
        self.selectView?.callback = { v  in
            self.value = v["datetime"]  as! String
        }
        UIViewController.current()?.view.addSubview(self.selectView!)
    }

}


class UIAODateView: UIAODialog{
    var dvalue = ""
    var dview:UIDatePicker!
    override var value: [String : Any]{
        get{
            let chooseDate = dview.date
            let dateFormater = DateFormatter.init()
            dateFormater.dateFormat = "YYYY-MM-dd"
            return ["datetime":"\(dateFormater.string(from: chooseDate))"]
        }
    }
    
    override func drawFromView(view: UIView) {
        dview = UIDatePicker(frame: view.bounds)
        dview.datePickerMode = .date
        dview.locale = Locale.init(identifier:"zh_CN")
        view.addSubview(dview)
    }
}


