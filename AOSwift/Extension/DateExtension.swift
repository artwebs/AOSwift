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
}
