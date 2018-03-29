//
//  DataExtension.swift
//  HolidayInChina
//
//  Created by 刘洪彬 on 2018/3/29.
//  Copyright © 2018年 artwebs. All rights reserved.
//

import Foundation


extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
