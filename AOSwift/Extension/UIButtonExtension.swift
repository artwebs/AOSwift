//
//  UIButtonExtension.swift
//  HongMengPF
//
//  Created by 刘洪彬 on 2019/11/20.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

extension UIButton {
    func buildCodeMiss(second:Int){
        var  i = second
        self.setTitle("重发(\(second))", for:.disabled)
        self.setTitleColor(.gray, for: .disabled)
        self.isEnabled=false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            i -= 1
            self.setTitle(String(format: "重发(%d)",i), for:.disabled)
            if i == 0 {
                timer.invalidate()
                self.isEnabled=true
                i = second
            }
        }
    }
}
