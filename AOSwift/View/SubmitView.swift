//
//  SubmitControl.swift
//  HolidayInChina
//
//  Created by 刘洪彬 on 2018/6/22.
//  Copyright © 2018年 artwebs. All rights reserved.
//

import UIKit
protocol SubmitViewDelegate {
    
}
class SubmitView: UIScrollView,SubmitViewDelegate {
    var submitViewdelegate:SubmitViewDelegate?
    private var param:Array<Dictionary<String,Any>>=[]
    private var defaultCellHeight:Float32 = 60
    private var cellViews = Dictionary<String,SubmitCellView>()
    
    override var views: Dictionary<String, UIView>{
        get{
            return cellViews
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
    }
    
    func append(item:Dictionary<String,Any>) ->  SubmitView{
        self.param.append(item)
        return self
    }
    
    func append(list:Array<Dictionary<String,Any>>) -> SubmitView {
        self.param += list
        return self
    }
    
    func clear()->SubmitView{
        self.param.removeAll()
        cellViews.removeAll()
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }
        return self 
    }
    
    func load() {
        self.backgroundColor = UIColor.clear
        UIView.translatesAutoresizingMaskIntoConstraintsFalse(cellViews)
        for row in self.param {
            let view  = SubmitCellView()
            view.reflect(row: row)
            self.initSubView(name: view.field, h: "H:|-0-[?]-0-|", v: "V:|-0-[?]-0-|")
            
        }
    }
    
    func getValues()->Dictionary<String,Any>{
        var rs = Dictionary<String,Any>()
        print(self.cellViews)
        for item in self.cellViews {
            rs[item.key] = item.value.getValue()
        }
        return rs
    }
}


class SubmitCellView:UIView{
    var field:String = ""
    var title:String = ""
    var type:String = "textbox"
    var readOnly:Bool = true
    var value:Any = ""
    var defautlValue:Any = ""
    
    func setDefaultValue(v:Any) {
        self.value = v
        self.defautlValue = v
    }
    
    func getValue() -> Any {
        return defautlValue;
    }
}
