//
//  UIAOScrollView.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/11/1.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAOScrollView: UIScrollView {
    var views = Dictionary<String,UIView>()
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
 
 
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        self.contentSize = CGSize(width: rect.width, height: rect.height+1600)
    }
 */

}
