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

protocol HttpRemoteCallBack{
    func remoteFinished(success success:[HttpService],fail:[HttpService])
}

protocol HttpServiceInterface {
    var cmd : String{ get}
}

class HttpService {
    var cmd : HttpServiceInterface
    var params : NSMutableDictionary?
    var callback : ((cmd : HttpServiceInterface, success :Bool,msg : String , data : Any?)->())?
    var status = HttpServiceStatus.run
    
    init(cmd:HttpServiceInterface,callback:(cmd : HttpServiceInterface, success :Bool,msg : String , data : Any?)->()){
        self.cmd=cmd
        self.params=nil
        self.callback=callback
    }
    
    init(cmd:HttpServiceInterface,params :NSMutableDictionary?){
        self.cmd=cmd
        self.params=params
        self.callback=nil
    }
    
    init(cmd:HttpServiceInterface,params :NSMutableDictionary?,callback:(cmd : HttpServiceInterface, success :Bool,msg : String , data : Any?)->()){
        self.cmd=cmd
        self.params=params
        self.callback=callback
    }
    
}


class HttpRemote {
    var isRun=false
    private var queue = NSOperationQueue()
    var apiRoot :String?{
        get{
            return nil
        }
    }
    private func newService(perfixUrl :String)->IServiceHttpSync?{
        //        println(AppDefault.DATA_API_ROOT+perfixUrl)
        if let root = self.apiRoot {
            return IServiceHttpSync(url:root+perfixUrl)
        }
        return nil
    }
    
    
    func defaultParams(param: NSMutableDictionary){
        
    }
    
    func postSync(command :HttpServiceInterface)->( HttpServiceInterface, Bool,String?, Any?){
        let (serviceObject,success,msg,data)=self.request(serviceObject: HttpService(cmd: command, params: NSMutableDictionary()))
        return (serviceObject.cmd, success, msg, data)
    }
    
    func post(command :HttpServiceInterface,callback : (cmd : HttpServiceInterface, success :Bool,msg : String , data : Any?)->()){
        post(list:[HttpService(cmd: command, params: NSMutableDictionary(), callback: callback)])
    }
    
    func post(obj obj:HttpService){
        post(list:[obj],rCallBack: nil)
    }
    
    func post(list list:[HttpService]){
        post(list:list,rCallBack: nil)
    }
    
    func post(list list:[HttpService], rCallBack: HttpRemoteCallBack?){
        if isRun {
            let alertView = UIAlertView(title: "提示", message: "操作过于频繁，请稍后再试！", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        isRun=true
        queue.maxConcurrentOperationCount = list.count;
        for item in list {
            queue.addOperationWithBlock({
                let (serviceObject,success,msg,data)=self.request(serviceObject: item)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    dispatch_sync(dispatch_get_main_queue(),{
                        item.callback?(cmd: serviceObject.cmd, success: success, msg: msg, data: data)
                    })
                })
                
                self.isRun=false
            })
        }
        
        let daemonQueue = NSOperationQueue()
        daemonQueue.maxConcurrentOperationCount = 1
        daemonQueue.addOperationWithBlock({
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                dispatch_sync(dispatch_get_main_queue(),{
                    rCallBack?.remoteFinished(success:successList,fail:failList)
                })
            })
        })
    }
    
    func stopRemote(){
        queue.cancelAllOperations()
    }
    
    
    private func request(serviceObject serviceObject:HttpService)->(serviceObject : HttpService, success :Bool,msg : String , data : Any?){
        let service = self.newService(serviceObject.cmd.cmd)
        let param = NSMutableDictionary()
        self.defaultParams(param)
        
        if let sparam = serviceObject.params{
            param.addEntriesFromDictionary(sparam as [NSObject : AnyObject])
        }
        
        var success = false
        var msg :String = "连接服务器超时！"
        var data :Any? = nil
        if let rs = service!.sendParems(param){
            let dic = Utils.JSONOjbectFromString(rs) as? NSDictionary
            serviceObject.status=HttpServiceStatus.fail
            msg = "数据解析错误"
            
            if dic != nil {
                if let tmp = dic?["status"] as? NSNumber{
                    if tmp.intValue == 2002{
                        serviceObject.status=HttpServiceStatus.success
                        success=true
                        msg = dic?["msg"] as! String
                        data = dic?["data"]
                        
                    }else{
                        msg = dic?["msg"]as! String
                    }
                }
            }
            
        }
        return ( serviceObject: serviceObject,success: success,msg: msg,data: data)
    }
}