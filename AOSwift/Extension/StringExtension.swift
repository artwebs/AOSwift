//
//  StringExtension.swift
//  RuralCadre
//
//  Created by rsmac on 15/9/7.
//  Copyright (c) 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    var toDictionary : Dictionary<String,Any>?{
        print(self.data(using: .utf8)?.hexString())
        let str = "{\"Code\":-1,\"Count\":0,\"Message\":\"成功\",\"Data\":null}"
        print(str.data(using: .utf8)?.hexString())
        if let data = str.data(using: .utf8){
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
        
    }
}
