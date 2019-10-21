//
//  UIAOSubmitCellViewImage.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/4/22.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class UIAOSubmitCellViewImage: UIAOSubmitCellView {
    @objc var name:String = ""
    @objc var label:String = ""
    @objc var type:String = "textbox"
    @objc var readOnly:Bool = false
    @objc var display:Bool = true
    @objc var value:String = ""
    @objc var placeHolder:String = ""
    @objc var views:Dictionary<String,UIView>=[:]
    
    override func setValue(val: String) {
        self.value = val
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        
    }
   
    override func reload() {
       views = self.layoutHelper(name: "label", h: "H:|-20-[?(120)]", v: "V:|-0-[?(40)]",views:views) { (view:UILabel) in
            view.text = self.label
            view.textColor = UIColor.black
        }
        
        views = self.layoutHelper(name: "Image", h: "H:|-20-[?(120)]", v: "V:[label]-0-[?(100)]",views:views) { (view:UIScrollView) in
            var allWidth:CGFloat = 0
            debugPrint(self.value)
            let items = self.value.split(separator: ";")
            for item in items{
                debugPrint(item)
                
                let imageView = UIImageView(frame: CGRect(x: allWidth, y: 0, width: 120, height: 100))
                imageView.loadRemoteUrl(String(item))
                view.addSubview(imageView)
                allWidth = allWidth + 10
            }
            
            
        }
    }
}
