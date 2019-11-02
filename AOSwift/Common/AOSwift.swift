//
//  AOSwift.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/15.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit
class AOSwift {
    static func alert(view:UIView?,message:String,handler: ((UIAlertAction)->Void)?){
        var cancelAction:UIAlertAction!;
        cancelAction = UIAlertAction(title: "确定", style: .cancel, handler:handler);
        let alertController = UIAlertController(title: "提示",
                                                message: message, preferredStyle: .alert)
        
        alertController.addAction(cancelAction)
        DispatchQueue.main.async(execute: {
            view?.vController?.present(alertController, animated: true, completion: nil)
        })
        
    }
}

var statusHeight:CGFloat{
    get{
        return UIApplication.shared.statusBarFrame.height
    }
}


func app()->AppDelegate{
    return UIApplication.shared.delegate as! AppDelegate
}

func statusBackground(color:UIColor){
    let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
    let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
    if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
        statusBar.backgroundColor = color
    }
}


func setRootViewController(_ identifier : String){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let rootViewController =  storyboard.instantiateViewController(withIdentifier: identifier)
    let nvc: UINavigationController = UINavigationController(rootViewController: rootViewController)
    
    app().window?.rootViewController = nvc
    app().window?.makeKeyAndVisible()
    
}

func setRootViewController(_ controller : UIViewController){
    let nvc: UINavigationController = UINavigationController(rootViewController: controller)
    app().window?.rootViewController = nvc
    app().window?.makeKeyAndVisible()
    
}


func instantViewController(_ identifier : String)->UIViewController{
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return  storyboard.instantiateViewController(withIdentifier: identifier)
}

func mainThread(_ f:@escaping ()->Void){
    DispatchQueue.main.async{
        f()
    }
}


