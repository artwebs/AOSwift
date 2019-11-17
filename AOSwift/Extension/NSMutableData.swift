//
//  NSMutableData.swift
//  HongMengPF
//
//  Created by 刘洪彬 on 2019/11/16.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
