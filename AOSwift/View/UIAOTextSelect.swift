//
//  UIAOTextSelect.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/21.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

class UIAOTextSelect: UIAOTextField {
    private var _value = ""
    override var value: Any{
        set{
            self._value = newValue as? String ?? ""
            self.text = dicOut?(self._value) ?? ""
        }
        get{
            return _value
        }
    }
    var dicOut:((String)->String)?
    var onClick:((UIAOButton)->Void)?
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.views = self.layoutHelper(name: "btn", h: "|-0-[?]-0-|", v: "|-0-[?]-0-|", views: self.views, delegate: { (v:UIAOButton) in
            v.click {
                self.onClick?(v)
            }
        })
    }
}
