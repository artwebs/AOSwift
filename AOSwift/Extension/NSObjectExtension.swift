//
//  NSObjectExtension.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/15.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import Foundation
extension NSObject{
    class var className: String { return String.className(self) }
    
    func reflect(row:Dictionary<String,Any>){
        let mirror: Mirror = Mirror(reflecting:self)
        for  children in mirror.children {
            print(children.label!)
            if let val = row[children.label!]{
                self.setValue(val, forKey: children.label!)
            }else{
//                print(children.label!)
            }
        }
    }
}
