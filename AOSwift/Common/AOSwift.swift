//
//  AOSwift.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/15.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit

func app()->AppDelegate{
    return UIApplication.shared.delegate as! AppDelegate
}

func setRootViewController(_ identifier : String){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let rootViewController =  storyboard.instantiateViewController(withIdentifier: identifier)
    let nvc: UINavigationController = UINavigationController(rootViewController: rootViewController)
    
    app().window?.rootViewController = nvc
    app().window?.makeKeyAndVisible()
    
}


func instantViewController(_ identifier : String)->UIViewController{
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return  storyboard.instantiateViewController(withIdentifier: identifier)
}

