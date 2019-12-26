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
    var remoteErr:[String:AnyObject]{
        get{
            return [:]
        }
    }
    
    func view(v:UIView) -> APIClient {
        self.view = v
        return self
    }
    
    func delete(path:APIDefine,append:String,params:[String:Any]?,callback:@escaping (_ res:HTTPURLResponse?, _ data:[String:AnyObject]?, _ error:Error?)->Void){
        var val = params
        let urlSession = URLSession.shared
        var url = rootUrl+path.cmd+append
        self.urlWithParam(url: &url, params: params)
        let before = self.linstener?.before(method:.GET, url:&url,params: &val)
        if !(before?.flag ?? true){
            return
        }
        var request = before?.request ?? buildRequest(url: url)
        request.httpMethod = "delete"
        debugPrint(request.httpMethod,url,val)
        let dataTask=urlSession.dataTask(with: request) { (data, res, error) in
            var json:[String : AnyObject] = self.remoteErr
            if error == nil{
                do {
                    try json = JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String:AnyObject] ?? self.remoteErr
                } catch  {
                    print(error.localizedDescription)
                }
            }
            callback(res as? HTTPURLResponse,json,error)
        }
        dataTask.resume()
    }
    
    func delete(path:APIDefine,params:[String:Any]?,callback:@escaping (_ res:HTTPURLResponse?, _ data:[String:AnyObject]?, _ error:Error?)->Void) {
        delete(path: path, append: "", params: params, callback:callback)
    }
    
    func get(path:APIDefine,append:String,params:[String:Any]?,callback:@escaping (_ res:HTTPURLResponse?, _ data:[String:AnyObject]?, _ error:Error?)->Void){
        var val = params
        let urlSession = URLSession.shared
        var url = rootUrl+path.cmd+append
        self.urlWithParam(url: &url, params: params)
        let before = self.linstener?.before(method:.GET, url:&url,params: &val)
        if !(before?.flag ?? true){
            return
        }
        var request = before?.request ?? buildRequest(url: url)
        request.httpMethod = "GET"
        debugPrint(url,val)
        let dataTask=urlSession.dataTask(with: request) { (data, res, error) in
            var json:[String : AnyObject] = self.remoteErr
            if error == nil{
                do {
                    try json = JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String:AnyObject] ?? self.remoteErr
                } catch  {
                    print(error.localizedDescription)
                }
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
        self.urlWithParam(url: &url, params: params)
        let before = self.linstener?.before(method:.POST, url:&url,params: &val)
        if !(before?.flag ?? true){
            return
        }
        var request = before?.request ?? buildRequest(url: url)
        self.setHeaderJson(request: &request)
        request.httpMethod = "POST"
        debugPrint(url,val)
        
        let dataTask=urlSession.dataTask(with: request) { (data, res, error) in
            var json:[String : AnyObject] = self.remoteErr
            do {
                try json = JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String:AnyObject] ?? self.remoteErr
            } catch  {
                print(error.localizedDescription)
            }
            callback(res as? HTTPURLResponse,json,error)
        }
        dataTask.resume()
    }
    
    func upload(path:APIDefine,name:String,fileURL:URL,params:[String:Any]?,callback:@escaping (_ res:HTTPURLResponse?, _ data:[String:AnyObject]?, _ error:Error?)->Void){
        var val = params
        var url = rootUrl+path.cmd;
        let before = self.linstener?.before(method: .POST, url:&url,params: &val)
        let fileData = try? Data.init(contentsOf: fileURL)
        if !(before?.flag ?? true){
            return
        }
        var request = before?.request ?? buildRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //发起请求
        request.httpBody = createBody(name:name,parameters: val as! [String : String],
                                boundary: boundary,
                                data:fileData!,
                                mimeType: "video/mpeg",
                                filename: "file.mp4")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, res, error) in
            var json:[String : AnyObject] = self.remoteErr
            if error == nil{
                do {
                    try json = JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String:AnyObject] ?? self.remoteErr
                } catch  {
                    print(error.localizedDescription)
                }
            }
            callback(res as? HTTPURLResponse,json,error)
        }
        //请求开始
        dataTask.resume()
    }
    
    func upload(path:APIDefine,name:String,image:UIImage,params:[String:Any]?,callback:@escaping (_ res:HTTPURLResponse?, _ data:[String:AnyObject]?, _ error:Error?)->Void){
        var val = params
        var url = rootUrl+path.cmd;
        let before = self.linstener?.before(method: .POST, url:&url,params: &val)
        if !(before?.flag ?? true){
            return
        }
        var request = before?.request ?? buildRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //发起请求
        request.httpBody = createBody(name:name,parameters: val as! [String : String],
                                boundary: boundary,
                                data: image.jpegData(compressionQuality: 1)!,
                                mimeType: "image/jpg",
                                filename: "file.jpg")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, res, error) in
            var json:[String : AnyObject] = self.remoteErr
            if error == nil{
                do {
                    try json = JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? [String:AnyObject] ?? self.remoteErr
                } catch  {
                    print(error.localizedDescription)
                }
            }
            callback(res as? HTTPURLResponse,json,error)
        }
        //请求开始
        dataTask.resume()
    }
    
    func buildRequest(url:String)->URLRequest{
        var request = URLRequest(url: URL(string:url.urlEncoded())!)
        request.timeoutInterval = 5.0 //设置请求超时为5秒
        return request
    }
    
    func setHeaderJson(request:inout URLRequest){
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
    }
    
    func urlWithParam(url:inout String,params:[String:Any]?){
        for item in params ?? [:] {
            url = url.replacingOccurrences(of: "{\(item.key)}", with: "\(item.value)")
        }
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
    
    
    func createBody(name:String,parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
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
