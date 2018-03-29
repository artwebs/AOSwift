//
//  HttpRemote.swift
//  wenhuababa
//
//  Created by rsimac on 15/12/17.
//  Copyright © 2015年 Yunnan Sofmit Zhongcheng Software Co.,Ltd. All rights reserved.
//

import Foundation
import AOCocoa


enum HttpServiceStatus{
    case run,success,fail,cancel
}

class Secret{
    var key:String
    var iv:String
    init(key:String,iv:String) {
        self.key=key
        self.iv=iv
    }
}

protocol HttpRemoteCallBack{
    func remoteFinished(success:[HttpService],fail:[HttpService])
}

protocol HttpServiceInterface {
    var cmd : String{ get}
}

class HttpService {
    var cmd : HttpServiceInterface
    var params : NSMutableDictionary?
    var callback : ((_ cmd : HttpServiceInterface,_ result:Dictionary<String,Any>?)->())?
    var status = HttpServiceStatus.run
    
    init(cmd:HttpServiceInterface,callback:@escaping (_ cmd : HttpServiceInterface, _ result:Dictionary<String,Any>?)->()){
        self.cmd=cmd
        self.params=nil
        self.callback=callback
    }
    
    init(cmd:HttpServiceInterface,params :NSMutableDictionary?){
        self.cmd=cmd
        self.params=params
        self.callback=nil
    }
    
    init(cmd:HttpServiceInterface,params :NSMutableDictionary?,callback:@escaping (_ cmd : HttpServiceInterface, _ result:Dictionary<String,Any>?)->()){
        self.cmd=cmd
        self.params=params
        self.callback=callback
    }
    
}


class HttpRemote {
    var isRun=false
    fileprivate var queue = OperationQueue()
    var apiRoot :String?{
        get{
            return nil
        }
    }
    fileprivate func newService(_ perfixUrl :String)->IServiceHttpSync?{
        if let root = self.apiRoot {
            return IServiceHttpSync(url:root+perfixUrl)
        }
        return nil
    }
    
    
    func defaultParams(_ param: NSMutableDictionary){
        
    }
    
    func secrets()->Dictionary<String,Secret>{
        return Dictionary<String,Secret>()
    }
    
    func decode(rs:String,secret:Secret)->String{
        return  SecurityDES(model: Int32(CBC.rawValue)).decode(with:rs, key: secret.key, iv: secret.iv)
    }
    
    func postSync(_ command :HttpServiceInterface)->( HttpServiceInterface,Dictionary<String,Any>?){
        let (serviceObject,result)=self.request(serviceObject: HttpService(cmd: command, params: NSMutableDictionary()))
        return (serviceObject.cmd, result)
    }
    
    func post(_ command :HttpServiceInterface,callback : @escaping (_ cmd : HttpServiceInterface, _ result:Dictionary<String,Any>?)->()){
        post(list:[HttpService(cmd: command, params: NSMutableDictionary(), callback: callback)])
    }
    
    func post(_ command :HttpServiceInterface,params: NSMutableDictionary, callback : @escaping (_ cmd : HttpServiceInterface, _ result:Dictionary<String,Any>?)->()){
        post(list:[HttpService(cmd: command, params: params, callback: callback)])
    }
    
    func post(obj:HttpService){
        post(list:[obj],rCallBack: nil)
    }
    
    func post(list:[HttpService]){
        post(list:list,rCallBack: nil)
    }
    
    func post(list:[HttpService], rCallBack: HttpRemoteCallBack?){
        if isRun {
            let alertView = UIAlertView(title: "提示", message: "操作过于频繁，请稍后再试！", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        isRun=true
        queue.maxConcurrentOperationCount = list.count;
        for item in list {
            queue.addOperation({
                let (serviceObject,result)=self.request(serviceObject: item)
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                    DispatchQueue.main.sync(execute: {
                        item.callback?(serviceObject.cmd, result)
                    })
                })
                
                self.isRun=false
            })
        }
        
        let daemonQueue = OperationQueue()
        daemonQueue.maxConcurrentOperationCount = 1
        daemonQueue.addOperation({
            self.queue.waitUntilAllOperationsAreFinished()
            var successList :[HttpService]=[]
            var failList :[HttpService]=[]
            for item in list{
                switch(item.status){
                case HttpServiceStatus.success:
                    successList.append(item)
                default:
                    failList.append(item)
                }
            }
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                DispatchQueue.main.sync(execute: {
                    rCallBack?.remoteFinished(success:successList,fail:failList)
                })
            })
        })
    }
    
    func stopRemote(){
        queue.cancelAllOperations()
    }
    
    
    fileprivate func request(serviceObject:HttpService)->(serviceObject : HttpService, result:Dictionary<String,Any>?){
        let service = self.newService(serviceObject.cmd.cmd)
        let param = NSMutableDictionary()
        self.defaultParams(param)
        
        if let sparam = serviceObject.params{
            param.addEntries(from: (sparam as NSDictionary) as! [AnyHashable: Any])
        }
        
        if let rs = service!.sendParems(param){
            for (id,secret) in self.secrets(){
                let start=rs.index(rs.startIndex, offsetBy: 2)
                if rs.substring(to: start) == id{
                    return ( serviceObject: serviceObject,result : self.decode(rs: rs.substring(from: start), secret: secret).toDictionary)
                }
            }
        }
        return ( serviceObject: serviceObject,result : nil)
    }
}
