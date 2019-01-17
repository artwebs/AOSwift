//
//  LanguageHelper.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/1/17.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

class LanguageHelper: NSObject {
    static let shareInstance = LanguageHelper()
    let def = UserDefaults.standard
    var bundle : Bundle?
    
    class func getString(key:String)->String{
        let bundle = LanguageHelper.shareInstance.bundle
        if let str = bundle?.localizedString(forKey: key, value: nil, table: "Localizable"){
            return str
        }
        return key
    }
    
    func initUserLanguage(){
        var str = def.value(forKey: "userLanguage") as? String
        if str?.lengthOfBytes(using: .utf8) == 0 || str == nil{
            
            
        }
        
    }
}
