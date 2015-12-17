//
//  UIImageExtension.swift
//  RuralCadre
//
//  Created by rsmac on 15/9/14.
//  Copyright (c) 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import UIKit
import AOCocoa

extension UIImageView{
    
    func imagePath( filename : String)->String{
        let path = Utils.documentsPath("CacheImage")
        if (NSFileManager.defaultManager().fileExistsAtPath(path)) == false {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true , attributes: nil )
            } catch _ {
            }
        }
        return (NSURL(string: path)?.URLByAppendingPathComponent(filename).absoluteString)!
    }
    
    func loadRemoteUrl( url : String){
        self.loadRemoteUrl(url, def: nil)
    }
    
    func loadRemoteUrlBig( url : String){
        self.loadRemoteUrl(url, def: "icon_img_loading_big.jpg")
    }
    
    func loadRemoteUrlSmall( url : String){
        self.loadRemoteUrl(url, def: "icon_img_loading_small.jpg")
    }
    
    func loadRemoteUrl( url : String, def : String?){
        if def != nil{
            self.image=UIImage(named: def!)
        }
        
        let filename = imagePath(Utils.base64EncodeWithString(url))
        if NSFileManager.defaultManager().fileExistsAtPath(filename){
            self.image = UIImage(contentsOfFile:filename)
            return
        }
        
        let daemonQueue = NSOperationQueue()
        daemonQueue.maxConcurrentOperationCount = 1
        daemonQueue.addOperationWithBlock({
            //            UIImage(data: NSData(contentsOfURL: NSURL(string: imageList[0])!)!)
            
            if let data = NSData(contentsOfURL: NSURL(string: url)!){
                data.writeToFile(filename, atomically: true)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    dispatch_sync(dispatch_get_main_queue(),{
                        self.image = UIImage(data:data)
                    })
                })

            }
        })
    }
}
