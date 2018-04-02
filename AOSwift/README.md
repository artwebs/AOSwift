### 远程请求远程数据
```

class Client: HttpRemote{
    override var apiRoot : String?{
        get{
            return AppDefault.DATA_API_ROOT;
        }
    }

    override func defaultParams(_ param: NSMutableDictionary) {

    }

    override func secrets() -> Dictionary<String, Secret> {
        return ["01":Secret(key: "xxxxxxxx", iv: "xxxxxxx")]
    }
}

Client().post(API.holiday) { (service, rs) in
    if 0 == rs?["code"] as? Int {
        return
    }
    if let rows = rs?["data"] as? Array<Dictionary<String,Any>>{
        print(rows)
    }
}
```
### 本地存储数据
```

```
