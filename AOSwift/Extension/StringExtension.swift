//
//  StringExtension.swift
//  RuralCadre
//
//  Created by rsmac on 15/9/7.
//  Copyright (c) 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import Foundation

extension Dictionary{
    
    func strValue(key:String)->String{
        return strValue(key: key, def: "")
    }
    
    func strValue(key:String,def:String)->String{
        let obj = self as? [String:Any]
        return obj?[key] as? String ?? def
    }
    
    func intValue(key:String)->Int{
        return intValue(key: key, def: 0)
    }
    
    func intValue(key:String,def:Int)->Int{
        let obj = self as? [String:Any]
        return obj?[key] as? Int ?? def
    }
    
    func doubleValue(key:String)->Double{
        return doubleValue(key: key, def: 0.00)
    }
    
    func doubleValue(key:String,def:Double)->Double{
        let obj = self as? [String:Any]
        return obj?[key] as? Double ?? def
    }
}

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    var toDictionary : Dictionary<String,Any>?{
        if let data = self.data(using: .utf8){
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
        
    }
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
