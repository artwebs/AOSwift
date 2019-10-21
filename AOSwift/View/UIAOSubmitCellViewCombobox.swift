//
//  UIAOSubmitCellViewCombobox.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/4/15.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class UIAOSubmitCellViewCombobox: UIAOSubmitCellView {
    @objc var name:String = ""
    @objc var label:String = ""
    @objc var type:String = "textbox"
    @objc var readOnly:Bool = false
    @objc var display:Bool = true
    @objc var value:String = ""
    @objc var textValue:String = ""
    @objc var placeHolder:String = ""
    @objc var views:Dictionary<String,UIView>=[:]
    
    override func getValue() -> String {
        return self.value
    }
    
    override func setValue(val: String) {
        self.value = val
    }
    
    override func getName() -> String {
        return self.name
    }
    
    override func setText(val: String) {
        self.textValue = val
        self.didChangeValue?()
    }
    
    override func setLabel(val: String) {
        self.label = val
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.reload()
    }
    override func reload() {
       views = self.layoutHelper(name: "label", h: "H:|-20-[?(120)]", v: "V:|-0-[label(40)]",views:views) { (view:UILabel) in
            
            view.text = label
            view.textColor = UIColor.black
            
        }
        
        views = self.layoutHelper(name: "ico", h: "H:[?(7)]-10-|", v: "V:|-15-[?(13)]",views:views) { (view:UIImageView) in
            view.image = UIImage(named: "icon_combobox_ico")
        }
        
        views = self.layoutHelper(name: "button", h: "H:[label]-[?]-[ico]", v: "V:|-0-[?(40)]",views:views) { (view:UILabel) in
            if "".elementsEqual(textValue){
                view.text = placeHolder
                view.textColor = UIColor.gray
            }else{
                view.text = self.textValue
                view.textColor = UIColor.black
            }
            
            view.textAlignment = .right
        }
    }
}
