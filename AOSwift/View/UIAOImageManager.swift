//
//  UIAOImageManager.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/9.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAOImageManager: UIAOView {
    var src:[String] = []
    private var editViews:[UIAOImageEdit] = []
    var lineCount = 4
    var maxCount = 8
    var onSelected:((UIAOImageEdit,UIImage)->Void)?
    var loadImage:((UIAOImageEdit,String)->Void)?
    var allWidth:CGFloat = 0
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func load(allWidth:CGFloat){
        self.allWidth = allWidth
        self.reload()
    }
    
    
    
    func reload(){
        self.views.removeAll()
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.editViews.removeAll()
        
        let margin:CGFloat = 10
        let size = ( allWidth - margin * CGFloat(lineCount + 1)) / CGFloat(lineCount)
        
        var top:CGFloat = 0
        var left:CGFloat = 0
        var index:Int = 0
       
        for item in src {
            print("item\(index)")
            left = margin * CGFloat(index%lineCount + 1) + size * CGFloat(index%lineCount)
            top = CGFloat(index / lineCount) * size + margin * CGFloat(index / lineCount + 1)
            self.views = self.layoutHelper(name: "item\(index)", h: "|-\(left)-[?(\(size))]", v: "|-\(top)-[?(\(size))]", views: self.views, delegate: { (v:UIAOImageEdit) in
                v.onSelected = self.onSelected
                v.loadImage = self.loadImage
                v.load(size: size)
                v.value = item
                
                self.editViews.append(v)
            })
            index = index + 1
        }
        if index <= maxCount{
           left = margin * CGFloat(index%lineCount + 1) + size * CGFloat(index%lineCount)
           top = CGFloat(index / lineCount) * size + margin * CGFloat(index / lineCount + 1)
           print("item\(index)")
           self.views = self.layoutHelper(name: "item\(index)", h: "|-\(left)-[?(\(size))]", v: "|-\(top)-[?(\(size))]", views: self.views, delegate: { (v:UIAOImageEdit) in
               v.onSelected = self.onSelected
               v.loadImage = self.loadImage
               v.load(size: size)
               self.editViews.append(v)
           })
           index = index + 1
       }
        
        
    }
    
    func setValue(view:UIAOImageEdit, value:String){
        if let index = self.editViews.firstIndex(of: view){
            if index < src.count {
                src[index] = value
            }else{
                src.append(value)
            }
        }
    }

}
