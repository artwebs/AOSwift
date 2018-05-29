//
//  Listener.swift
//  HolidayInChina
//
//  Created by 刘洪彬 on 2018/5/29.
//  Copyright © 2018年 artwebs. All rights reserved.
//

import UIKit

class UIListener: NSObject {
    private var _listeners = Dictionary<UIView, () -> ()>()
    
    func set(view:UIView,listener: @escaping ()->()){
        self._listeners[view] = listener
    }
    
    func get(view:UIView) -> (() -> ())? {
        if let listener = self._listeners[view]{
            return listener
        }
        return nil
    }
}
