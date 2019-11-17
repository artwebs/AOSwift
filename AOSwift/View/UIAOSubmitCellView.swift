//
//  UIAOSubmitCellView.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/4/15.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class UIAOSubmitCellView:UITableViewCell{
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    var didFinish:(()->Void)?
    var didChangeValue:(()->Void)?
    func getValue() -> String {
        return "";
    }
    
    func getName() -> String {
        return ""
    }
    
    func setText(val:String) {
        
    }
    
    func setValue(val:String){
        
    }
    
    func getLabel() -> String {
        return ""
    }
    
    func setLabel(val:String) {
        
    }
    
    func wilBegin(fn:(()->Void)?){
        
    }
    
    func reload(){
        
    }
    
}
