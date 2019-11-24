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
    var view:UIAOView!
    var viewSize:CGSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+200)
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     */

    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        self.view = UIAOView(frame: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
//        self.contentSize = viewSize
//        self.addSubview(view)
    }
}
