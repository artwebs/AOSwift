//
//  UIAOSettingView.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/9.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit
import AOCocoa

class UIAOSettingView: UIAOView {
    var lineHeight:CGFloat = 70
    var margin:CGFloat = 20
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func load(param:[[String:Any]],draw:((UIAOButton,[String:Any])->Void)){
        self.views.removeAll()
        var height:CGFloat = 0
        for (index,item) in param.enumerated(){
            if index != 0 {
                self.views = self.layoutHelper(name: "line\(index)", h: "|-\(margin)-[?]-\(margin)-|", v: "|-\(height)-[?(2)]", views: self.views, delegate: { (v:UIImageView) in
                    v.image = Utils.createImage(with: AppDefault.DefaultLightGray)
                })
                height = height + 2
            }
            
            self.views = self.layoutHelper(name: "settin\(index)", h: "|-\(margin)-[?]-\(margin)-|", v: "|-\(height)-[?(\(lineHeight))]", views: self.views, delegate: { (v:UIAOButton) in
                draw(v,item)
            })
            height = height + lineHeight
        }
    }

}
