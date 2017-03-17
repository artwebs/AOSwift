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
    
    func imagePath( _ filename : String)->String{
        let path = Utils.documentsPath("CacheImage")
        if (FileManager.default.fileExists(atPath: path!)) == false {
            do {
                try FileManager.default.createDirectory(atPath: path!, withIntermediateDirectories: true , attributes: nil )
            } catch _ {
            }
        }
        return (URL(string: path!)?.appendingPathComponent(filename).absoluteString)!
    }
    
    func loadRemoteUrl( _ url : String){
        self.loadRemoteUrl(url, def: nil)
    }
    
    func loadRemoteUrlBig( _ url : String){
        self.loadRemoteUrl(url, def: "icon_img_loading_big.jpg")
    }
    
    func loadRemoteUrlSmall( _ url : String){
        self.loadRemoteUrl(url, def: "icon_img_loading_small.jpg")
    }
    
    func loadRemoteUrl( _ url : String, def : String?){
        if def != nil{
            self.image=UIImage(named: def!)
        }
        
        let filename = imagePath(Utils.base64Encode(with: url))
        if FileManager.default.fileExists(atPath: filename){
            self.image = UIImage(contentsOfFile:filename)
            return
        }
        
        let daemonQueue = OperationQueue()
        daemonQueue.maxConcurrentOperationCount = 1
        daemonQueue.addOperation({
            //            UIImage(data: NSData(contentsOfURL: NSURL(string: imageList[0])!)!)
            
            if let data = try? Data(contentsOf: URL(string: url)!){
                try? data.write(to: URL(fileURLWithPath: filename), options: [.atomic])
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                    DispatchQueue.main.sync(execute: {
                        self.image = UIImage(data:data)
                    })
                })

            }
        })
    }
}
