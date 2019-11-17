//
//  APIClient.swift
//  RakubaiIOS
//
//  Created by 刘洪彬 on 2019/10/12.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit


protocol APIDefine {
    var cmd : String{ get}
}

enum APIMethod:String{
    case GET = "GET"
    case POST = "POST"
}

protocol APIClientListener{
    func before(method:APIMethod, url:inout String,params: inout [String:Any]?)->(flag:Bool,request:URLRequest)
}


class APIClient: NSObject {
    var rootUrl:String=""
    var view:UIView?
    var linstener:APIClientListener?
    
    func view(v:UIView) -> APIClient {
        self.view = v
        return self
    }
    
    func get(path:APIDefine,append:String,params:[String:Any]?,callback:@escaping (_ res:HTTPURLResponse?, _ data:[String:AnyObject]?, _ error:Error?)->Void){
        var val = params
        let urlSession = URLSession.shared
        var url = rootUrl+path.cmd+append
        let before = self.linstener?.before(method:.GET, url:&url,params: &val)
        if !(before?.flag ?? true){
            return
        }
        var request = before?.request ?? buildRequest(url: url)
        request.httpMethod = "GET"
        debugPrint(url,val)
        
        let dataTask=urlSession.dataTask(with: request) { (data, res, error) in
            var json:[String : AnyObject] = [:]
            if error == nil{
                print(error)
                json = try!JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String:AnyObject] ?? [:]
            }
            callback(res as? HTTPURLResponse,json,error)
        }
        dataTask.resume()
    }
    
    
    
    func get(path:APIDefine,params:[String:Any]?,callback:@escaping (_ res:HTTPURLResponse?, _ data:[String:AnyObject]?, _ error:Error?)->Void) {
        get(path: path, append: "", params: params, callback:callback)
    }
    
    func post(path:APIDefine,params:[String:Any]?,callback:@escaping (_ res:HTTPURLResponse?, _ data:[String:AnyObject]?, _ error:Error?)->Void)  {
        var val = params
        let urlSession = URLSession.shared
        
        var url = rootUrl+path.cmd;
        
        let before = self.linstener?.before(method:.POST, url:&url,params: &val)
        if !(before?.flag ?? true){
            return
        }
        var request = before?.request ?? buildRequest(url: url)
        request.httpMethod = "POST"
        debugPrint(url,val)
        
        let dataTask=urlSession.dataTask(with: request) { (data, res, error) in
            var json:[String : AnyObject] = [:]
            if error == nil{
                print(error)
                json = try!JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String:AnyObject] ?? [:]
            }
            callback(res as? HTTPURLResponse,json,error)
        }
        dataTask.resume()
    }
    
    func buildRequest(url:String)->URLRequest{
        var request = URLRequest(url: URL(string:url.urlEncoded())!)
        request.timeoutInterval = 5.0 //设置请求超时为5秒
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        return request
    }
    
    func paramToUrl(url:inout String,params:[String:Any]?) {
        for item in params ?? [:] {
            if url.contains("?"){
                url = url + "&"
            }else{
                url = url + "?"
            }
            url = url+"\(item.key)=\(item.value)"
        }
    }
    
    func paramToJSON(request:inout URLRequest,params:[String:Any]?) {
        if let tmp = params{
            request.httpBody = try! JSONSerialization.data(withJSONObject: tmp, options: .prettyPrinted)
        }
    }
    
    static func isSuccess(res:HTTPURLResponse?,data:[String:AnyObject])->(Bool,String){
        if let code = res?.statusCode,code == 200{
            if data["succeed"] as? Int == 1{
                return (true,data["msg"] as! String)
            }else{
                return (false,data["msg"] as! String)
            }
        }
        return (false,"网络异常")
    }
}
