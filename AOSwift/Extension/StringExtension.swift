//
//  StringExtension.swift
//  RuralCadre
//
//  Created by rsmac on 15/9/7.
//  Copyright (c) 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import Foundation

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
}