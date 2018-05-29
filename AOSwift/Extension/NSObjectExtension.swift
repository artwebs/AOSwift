//
//  NSObjectExtension.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/15.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import Foundation
extension NSObject{
    class var identifier: String { return String.className(self) }
}
