//
//  DateExtension.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/12/21.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
       return components.day ?? 0
    }
    
    func secondBetween(toDate:Date)->Int{
        let components = Calendar.current.dateComponents([.second], from: self, to: toDate)
        return components.second ?? 0
    }
    
    static func strFormat(from:String,format:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let time = dateFormatter.date(from: from){
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: time)
        }
        return ""
    }
    
    static func strFormatDate(from:String)->String{
        return strFormat(from: from, format: "yyyy-MM-dd")
    }
    
}
