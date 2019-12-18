//
//  AOSwift.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/15.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit
struct ConfirmConfig{var title:String,btn1:String,btn2:String}

class AOSwift {
    static var isDebug = true
    
    static func alert(size:CGSize,from:(UIAOView,UIAOView)->Void){
        let rect = UIScreen.main.bounds
        let alertView = UIAOView(frame: rect)
        var width = size.width
        var height = size.height
        alertView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        width = width > rect.width-20 ? rect.width-20:width
        height = height > rect.height-80 ? rect.height-20:height
        let container = UIAOView(frame: CGRect(x: 10, y: 40, width: width, height: height))
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        container.backgroundColor = UIColor.white
        container.center = CGPoint(x: rect.width*0.5, y: rect.height*0.5)
        alertView.addSubview(container)
        UIViewController.current()?.view.addSubview(alertView)
        from(container,alertView)
    }
    
    static func alert(message:String,handler: ((UIAlertAction)->Void)?){
        let alertController = UIAlertController(title: "提示",
                                                message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler:handler))
        DispatchQueue.main.async(execute: {
            UIViewController.current()?.present(alertController, animated: true, completion: nil)
        })
        
    }
    static func confirm(message:String,success:(()->Void)?){
        confirm(message: message, success: success, fail: nil)
    }
    
    static func confirm(message:String,success:(()->Void)?,fail:(()->Void)?){
        confirm(message: message, config: ConfirmConfig(title: "提示", btn1:"确定", btn2:"取消"), success: success, fail: fail)
    }
    
    static func confirm(message:String,config:ConfirmConfig, success:(()->Void)?,fail:(()->Void)?){
        let alertController = UIAlertController(title: config.title,
      message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title:config.btn1, style: .default, handler: {(alert) in
            success?()
        }))
       alertController.addAction(UIAlertAction(title: config.btn2, style: .cancel, handler:{(alert) in
           fail?()
       }))
       DispatchQueue.main.async(execute: {
            UIViewController.current()?.present(alertController, animated: true, completion: nil)
       })
    }
    
    static func confirm(message:String,textView:((UITextField)->Void)?,success:((String?)->Void)?){
        confirm(message: message, textView: textView, success: success, fail: nil)
    }
    
    static func confirm(message:String,textView:((UITextField)->Void)?,success:((String?)->Void)?,fail:(()->Void)?){
        let alertController = UIAlertController(title: "提示",message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textView?(textField)
        }
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: {(alert) in
            success?(alertController.textFields?.first?.text)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler:{(alert) in
           fail?()
        }))
        DispatchQueue.main.async(execute: {
            UIViewController.current()?.present(alertController, animated: true, completion: nil)
        })
    }
    
    static func debugValue(param:[String:AnyObject])->[String:AnyObject]{
        if (!isDebug){
            return [:]
        }
        return param
    }
    
    static func debugLog(tag:String, act:()->Void){
        if (!isDebug){
            return
        }
        print("\(tag) >>")
        act()
    }
    
    static func statusBar()->UIView{
        if #available(iOS 13.0, *){
            return UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        }else{
            let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
            let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
            return statusBar
        }
    }

}

var statusHeight:CGFloat{
    get{
        return UIApplication.shared.statusBarFrame.height
    }
}

var screenSize:CGSize{
    get{
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}


func app()->AppDelegate{
    return UIApplication.shared.delegate as! AppDelegate
}



func statusBackground(color:UIColor){
    let statusBar : UIView = AOSwift.statusBar()
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


