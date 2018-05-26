//
//  Table.swift
//  HolidayInChina
//
//  Created by 刘洪彬 on 2018/4/11.
//  Copyright © 2018年 artwebs. All rights reserved.
//

import UIKit
import AOCocoa
class Table: NSObject {
    private var name: String
    private var prefix:String?
    private var field:String?
    private var join:String?
    private var wher:String?
    private var group:String?
    private var order:String?
    private var having:String?
    private var limit:String?
    private var db:SqliteHelper?
    
    init(name:String){
        self.name=name
    }
    
    init(name:String, prefix:String){
        self.name=name
        self.prefix=prefix
    }
    
    func from(db:SqliteHelper)->Table{
        self.db=db
        return self
    }
    
    func select()->Array<Dictionary<String,Any>>{
        let sql=String(format: "select %@ from %@%@%@%@%@%@%@%@%"
            ,self.field ?? "*"
            ,self.prefix ?? ""
            ,self.name
            ,self.join ?? ""
            ,self.wher ?? ""
            ,self.order ?? ""
            ,self.group ?? ""
            ,self.having ?? ""
            ,self.limit ?? ""
        )
        return self.db?.query(sql) as? Array<Dictionary<String,Any>> ?? []
    }
    
    func find()->Dictionary<String,Any>{
        let list=self.limit(limit: "0,1").select();
        if list.count==0{
            return Dictionary<String,Any>()
        }else{
            return list[0]
        }
    }
    
    func total()->Int{
        self.field = "count(*) as c"
        let list = self.select()
        return list.count>0 ? (self.select()[0]["c"] as? Int ?? 0) : 0
    }
    
    func insert(row:Dictionary<String,Any>)->Int32{
        var key="",value=""
        for item in row{
            if key != ""{
                key+=","
                value+=","
            }
             key+="\(item.key)"
            switch item.value {
            case is Int:
                value+="\(item.value)"
            default:
                value+="'\(item.value)'"
            }
        }
        let sql=String(format: "insert into %@%@ (%@) values (%@)"
            ,self.prefix ?? "",self.name,key,value)
        return self.db?.exec(sql) ?? 0
    }
    
    func update(row:Dictionary<String,Any>)->Int32{
        var sql=""
        for item in row{
            if sql != ""{
                sql+=","
            }
            sql+="\(item.key)="
            switch item.value {
            case is Int:
                sql+="\(item.value)"
            default:
                sql+="'\(item.value)'"
            }
        }
        sql=String(format: "update %@%@ set %@%@", self.prefix ?? "",self.name,sql,self.wher ?? "")
        return self.db?.exec(sql) ?? 0
    }
    
    func delete()->Int32{
        let sql=String(format: "delete from  %@%@%@", self.prefix ?? "",self.name,self.wher ?? "")
        return self.db?.exec(sql) ?? 0
    }
    
    func field(field:String...) -> Table {
        for item in field{
            if self.field == nil{
                self.field=" \(item)"
            }else{
                self.field!+=",\(item)"
            }
            
        }
        return self
    }
    
    func join(join:String...) -> Table {
        for item in join{
            if self.field == nil{
                self.join=" \(item)"
            }else{
                self.join!+=" \(item)"
            }
        }
        return self
    }
    
    func wher(wher:String...)->Table{
        for item in wher{
            if(self.wher == nil){
                self.wher=" where (\(item))"
            }else{
                self.wher!+=" and (\(item))"
            }
        }
        return self
    }
    
    func group(group:String...)->Table{
        for item in group{
            if(self.group == nil){
                self.group=" group by \(item)"
            }else{
                self.group!+=",\(item)"
            }
        }
        return self
    }
    
    func order(order:String...)->Table{
        for item in order{
            if(self.order == nil){
                self.order=" order by \(item)"
            }else{
                self.order!+=",\(item)"
            }
        }
        return self
    }
    
    func having(having:String)->Table{
        self.having=" having \(having)"
        return self
    }
    
    func limit(limit:String)->Table{
        self.limit = " limit \(limit)"
        return self
    }
}
