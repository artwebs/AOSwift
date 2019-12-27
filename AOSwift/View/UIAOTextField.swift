//
//  UIAOTextField.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/9.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAOTextField: UITextField,UIAOFormControl,UITextFieldDelegate {
    private var _vaild:UIAOFormVaild?
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
    
    var views = Dictionary<String,UIView>()
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    var value: Any{
        set{ self.text = newValue as? String}
        get{ return self.text ?? ""}
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setValue(12, forKey: "paddingLeft")
        self.setValue(12, forKey: "paddingRight")
        self.delegate = self
        self.addDoneButtonOnKeyboard()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.value = textField.text as? String ?? ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        self.finish?(self)
        return true
    }
    
    override func doneButtonAction() {
        self.resignFirstResponder()
        self.finish?(self)
    }
    
    

}
