//
//  UIViewController.swift
//  Yixiang
//
//  Created by 刘洪彬 on 2019/11/25.
//  Copyright © 2019 artwebs. All rights reserved.
//

import UIKit

extension UIViewController {
    class func current(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }
    
    
}
