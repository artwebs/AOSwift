//
//  UIAOSubmitCellViewTextbox.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/4/15.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class UIAOSubmitCellViewTextbox:UIAOSubmitCellView,UITextFieldDelegate{
    @objc var name:String = ""
    @objc var label:String = ""
    @objc var type:String = "textbox"
    @objc var readOnly:Bool = false
    @objc var display:Bool = true
    @objc var single:Bool = true
    @objc var value:String = ""
    @objc var placeHolder:String = ""
    @objc var views:Dictionary<String,UIView>=[:]
    @objc var model = "string"
    
    var edit:UITextField?{
        get{
            return views["textbox"] as? UITextField
        }
    }
    
    override func wilBegin(fn:(()->Void)?){
        self.edit?.becomeFirstResponder()
        fn?()
    }
    
    override func getValue() -> String {
        if let val = edit?.text{
            return val
        }else{
            return ""
        }
    }
    
    
    override func setValue(val: String) {
        self.value = val
    }
    
    override func getName() -> String {
        return self.name
    }
    
    override func setText(val: String) {
        self.value = val
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.reload()
    }
    
    override func reload() {
        if single{
            views = self.layoutHelper(name: "label", h: "H:|-20-[?(120)]", v: "V:|-0-[label(40)]",views:views) { (view:UILabel) in
                view.text = self.label
                view.textColor = UIColor.black
            }
            views = self.layoutHelper(name: "textbox", h: "H:[label]-0-[?]-10-|", v: "V:|-4-[?(36)]",views:views) { (view:UITextField) in
                view.textAlignment = .right
                view.setValue(12, forKey: "paddingLeft")
                view.setValue(12, forKey: "paddingRight")
                view.delegate = self
                
                switch self.model{
                case "number":view.keyboardType=UIKeyboardType.numberPad ;break;
                case "decimal":view.keyboardType=UIKeyboardType.decimalPad ;break;
                case "email":view.keyboardType=UIKeyboardType.emailAddress ;break;
                case "phone":view.keyboardType=UIKeyboardType.phonePad ;break;
                case "url":view.keyboardType=UIKeyboardType.URL ;break;
                case "ascii":view.keyboardType=UIKeyboardType.asciiCapable ;break;
                case "asciiNumber":view.keyboardType=UIKeyboardType.asciiCapableNumberPad ;break;
                default:break;
                }
                
                if "".elementsEqual(self.value){
                    view.placeholder = placeHolder
                    view.text = ""
                }else{
                    view.placeholder = placeHolder
                    view.text = self.value
                }
                if self.readOnly{
                    view.isEnabled = false
                }else{
                    view.isEnabled = true
                }
                didFinish?()
            }
        }else{
            views = self.layoutHelper(name: "textbox", h: "H:|-10-[?]-10-|", v: "V:|-4-[?(100)]",views:views) { (view:UITextField) in
                view.textAlignment = .left
                view.setValue(12, forKey: "paddingLeft")
                view.setValue(12, forKey: "paddingRight")
                view.delegate = self
                if "".elementsEqual(self.value){
                    view.placeholder = placeHolder
                    view.text = ""
                }else{
                    view.placeholder = placeHolder
                    view.text = self.value
                }
                if self.readOnly{
                    view.isEnabled = false
                }else{
                    view.isEnabled = true
                }
                didFinish?()
            }
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.value = self.getValue()
        self.didChangeValue?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.value = self.getValue()
        didFinish?()
        return true
    }
}
