//
//  SubmitControl.swift
//  HolidayInChina
//
//  Created by 刘洪彬 on 2018/6/22.
//  Copyright © 2018年 artwebs. All rights reserved.
//

import UIKit
import AOCocoa
@objc protocol SubmitViewDelegate {
   func submitViewForParam(submitView:SubmitView)->Array<Dictionary<String,Any>>;
   @objc optional func submitViewForCell(submitView:SubmitView,cell:SubmitCellView,index:Int);
}
class SubmitView: UIScrollView {
    var submitViewdelegate:SubmitViewDelegate?
    private var defaultCellHeight:Float32 = 60
    private var cellViews = Dictionary<String,SubmitCellView>()
    
    override func draw(_ rect: CGRect) {
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
    }
    
    func clear(){
        cellViews.removeAll()
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    func load() {
        self.clear()
        self.backgroundColor = UIColor.clear
        if let param = self.submitViewdelegate?.submitViewForParam(submitView: self){
            for i in 0..<param.count{
                let row=param[i]
                let v = i==0 ? "V:|-0-[?(60)]" : "V:[\(param[i-1]["field"] as! String)]-2-[?(60)]"
                
                cellViews = self.layoutHelper(name: row["field"] as! String, h: "H:|-0-[?(\(self.frame.width))]-0-|", v: v,views:cellViews ) { (view:SubmitCellView) in
                    view.reflect(row: row)
                    self.submitViewdelegate?.submitViewForCell?(submitView: self, cell: view, index: i)
                    } as! [String : SubmitCellView]
            }
        }
        
    }
    
    func getValues()->Dictionary<String,Any>{
        var rs = Dictionary<String,Any>()
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
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        var views = self.layoutHelper(name: "label", h: "H:|-0-[?(100)]", v: "V:|-0-[label(60)]",views:self.initViews()) { (view:UILabel) in
            view.text = self.title
        }
        views = self.layoutHelper(name: "textbox", h: "H:[label]-0-[?]-0-|", v: "V:|-12-[?(36)]",views:views) { (view:UITextField) in
            view.layer.cornerRadius  = 4.0
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.setValue(12, forKey: "paddingLeft")
        }
        
    }
}