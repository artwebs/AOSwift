//
//  UIAOSelectButton.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/11/29.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit
import AOCocoa

class UIAOSelectButton:UIAOView{
    var data:[[String:String]] = []
    var lineCount = 3
    var btnViews:[UIButton] = []
    var selectIndex = 0
    var selectRow:[String:String] = [:]
    var onStyle:((UIButton)->Void)?
    var unStyle:((UIButton)->Void)?
    
    
    var value:String{
        get{
            return selectRow["id"] ?? ""
        }
    }
    
    func load(title:String,allWidth:CGFloat,items:[[String:String]]){
        for view in self.subviews{
            view.removeFromSuperview()
        }
        btnViews.removeAll()
        self.data = items
        self.views = self.layoutHelper(name: "title", h: "|-10-[?]-10-|", v: "|-0-[?(30)]", views: self.views, delegate: { (v:UILabel) in
            v.text = title
            v.textColor = AppDefault.DefaultGray
        })
        self.views = self.layoutHelper(name: "line", h: "|-10-[?]-10-|", v: "[title]-0-[?(2)]", views: self.views, delegate: { (v:UIImageView) in
            v.image = Utils.createImage(with: AppDefault.DefaultLightGray)
        })
        
        
        let height:CGFloat = 30
        let margin:CGFloat = 10
        let width = ( allWidth - margin * CGFloat(lineCount + 1)) / CGFloat(lineCount)
        var top:CGFloat = 0
        var left:CGFloat = 0
        var index:Int = 0
        for item in items {
            left = margin * CGFloat(index%lineCount + 1) + width * CGFloat(index%lineCount)
            top = CGFloat(index / lineCount) * height + margin * CGFloat(index / lineCount + 1)
            self.views = self.layoutHelper(name: "item\(index)", h: "|-\(left)-[?(\(width))]", v: "[line]-\(top)-[?(30)]", views: self.views, delegate: { (v:UIButton) in
                v.setTitle(item["text"], for: .normal)
                self.unselectedStyle(v: v)
                btnViews.append(v)
                self.click(v, listener: {
                    self.toSelect(v: v)
                })
            })
            index = index + 1
        }
    }
    
    func toSelect(index:Int){
        toSelect(v: self.btnViews[index])
    }
    
    func toSelectById(id:String){
        for (i,row) in self.data.enumerated(){
            if id == row["id"]{
                toSelect(v: self.btnViews[i])
                return
            }
            
        }
    }
    
    func toSelect(v:UIButton){
        for (i,item) in btnViews.enumerated(){
            if item == v{
                self.selectIndex = i
                self.selectRow = self.data[i]
                self.selectedStyle(v: item)
            }else{
                self.unselectedStyle(v: item)
            }
        }
    }
    
    func selectedStyle(v:UIButton) {
        if let act  = onStyle{
            act(v)
            return
        }
        v.setTitleColor(.white, for: .normal)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        v.layer.borderColor = AppDefault.DefaultGray.cgColor
        v.layer.borderWidth = 0
        v.setBackgroundImage(Utils.createImage(with: AppDefault.DefaultBlue), for: .normal)
        
    }
    
    func unselectedStyle(v:UIButton) {
        if let act  = unStyle{
            act(v)
            return
        }
        v.setTitleColor(AppDefault.DefaultGray, for: .normal)
        v.layer.borderColor = AppDefault.DefaultGray.cgColor
        v.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        v.layer.borderWidth = 1
        v.setBackgroundImage(Utils.createImage(with: .white), for: .normal)
    }
}
