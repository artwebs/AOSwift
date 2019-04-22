//
//  SubmitControl.swift
//  HolidayInChina
//
//  Created by 刘洪彬 on 2018/6/22.
//  Copyright © 2018年 artwebs. All rights reserved.
//

import UIKit
import AOCocoa
@objc protocol UIAOSubmitViewDelegate {
     @objc optional func submitViewForParam(submitView:UIAOSubmitView)->Array<Array<Dictionary<String,Any>>>;
    @objc optional func submitViewForValue(submitView:UIAOSubmitView)->[String:AnyObject];
    @objc optional func submitViewForCell(submitView:UIAOSubmitView,cell:UIAOSubmitCellView,index:Int);
    @objc optional func submitViewDidClick(submitView:UIAOSubmitView,cell:UIAOSubmitCellView,index:IndexPath);
    @objc optional func submitViewForCellHeight(submitView:UIAOSubmitView,indexPath: IndexPath)->CGFloat
    @objc optional func submitViewForValueChange(submitView:UIAOSubmitView,cell:UIAOSubmitCellView,index:IndexPath);
    @objc optional func submitViewDidFinish(submitView:UIAOSubmitView);
    
}
class UIAOSubmitView: UITableView,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    var submitViewdelegate:UIAOSubmitViewDelegate?
    private var defaultCellHeight:CGFloat = 44
    private var cellViews = Dictionary<String,UIAOSubmitCellView>()
    var layoutParams:Array<Array<Dictionary<String,Any>>>?
    private var layoutValues:[String:AnyObject]?
    
    override func draw(_ rect: CGRect) {
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        self.delegate = self;
        self.dataSource=self;
        if let pms = self.submitViewdelegate?.submitViewForParam?(submitView: self){
            self.layoutParams = pms
        }
        
        self.tableFooterView = UIView(frame: CGRect.zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        self.tableFooterView = UIView()
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        let info = notification.userInfo
        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: 0, bottom: kbRect.size.height, right: 0)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: 0, bottom: 0, right: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rs=0;
        if let list = layoutParams{
            rs = list[section].count;
        }
        return rs;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let params = layoutParams{
            return params.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.submitViewdelegate?.submitViewForCellHeight?(submitView: self, indexPath: indexPath){
            return height;
        }else{
            return defaultCellHeight;
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UIAOSubmitCellView?
        self.layoutValues = self.submitViewdelegate?.submitViewForValue?(submitView: self)
        if let params = self.layoutParams{
            let param = params[indexPath.section]
            let row=param[indexPath.row]
            let name = row["name"] as! String
            
            switch(row["type"] as! String){
            case "button":
                cell=tableView.dequeueReusableCell(withIdentifier:name) as? UIAOSubmitCellViewTextbox
                if cell == nil{
                    cell = UIAOSubmitCellViewTextbox(style: .default, reuseIdentifier: name)
                }
                
                if let view = cell{
                    view.reflect(row: row)
                    self.submitViewdelegate?.submitViewForCell?(submitView: self, cell: view, index: indexPath.row)
                    if param.count>indexPath.row+1{
                        view.didFinish={ 
                            //                            self.cellViews[param[indexPath.row+1]["name"] as! String]?.edit?.becomeFirstResponder()
                        }
                    }else{
                        view.didFinish={
                            //                            self.cellViews[param[indexPath.row]["name"] as! String]?.edit?.resignFirstResponder()
                        }
                    }
                }
                
                break
            case "textbox": cell=tableView.dequeueReusableCell(withIdentifier:name) as? UIAOSubmitCellViewTextbox
                if cell == nil{
                    cell = UIAOSubmitCellViewTextbox(style: .default, reuseIdentifier: name)
                }
                
                if let view = cell as? UIAOSubmitCellViewTextbox{
                     view.reflect(row: row)
                    self.submitViewdelegate?.submitViewForCell?(submitView: self, cell: view, index: indexPath.row)
                    if let values = self.layoutValues  {
                        if let val = values[row["name"] as! String] as? String{
                            view.setValue(val: val )
                        }
                    }
                    if param.count>indexPath.row+1{
                        view.didFinish={
                            if let next = self.cellViews[param[indexPath.row+1]["name"] as! String] as? UIAOSubmitCellViewTextbox{
                                next.edit?.becomeFirstResponder()
                            }
                           
                        }
                    }else{
                        view.didFinish={
                            view.edit?.resignFirstResponder()
                        }
                    }
                    view.didChangeValue={
                         self.submitViewdelegate?.submitViewForValueChange?(submitView: self, cell: view, index: indexPath)
                    }
                }
            case "combobox": cell=tableView.dequeueReusableCell(withIdentifier:name) as? UIAOSubmitCellViewCombobox
                if cell == nil{
                    cell = UIAOSubmitCellViewCombobox(style: .default, reuseIdentifier: name)
                }
                if let view = cell as? UIAOSubmitCellViewCombobox{
                    view.reflect(row: row)
                    self.submitViewdelegate?.submitViewForCell?(submitView: self, cell: view, index: indexPath.row)
                    if let values = self.layoutValues  {
                        if let val = values[row["name"] as! String] as? String {
                            view.setValue(val: val )
                        }
                    }
                    view.didFinish={
                        
                    }
                    view.didChangeValue={
                        self.submitViewdelegate?.submitViewForValueChange?(submitView: self, cell: view, index: indexPath)
                    }
                }
            case "image":
                cell=tableView.dequeueReusableCell(withIdentifier:name) as? UIAOSubmitCellViewImage
                if cell == nil{
                    cell = UIAOSubmitCellViewImage(style: .default, reuseIdentifier: name)
                }
                if let view = cell as? UIAOSubmitCellViewImage{
                    view.reflect(row: row)
                    if let values = self.layoutValues  {
                        if let val = values[row["name"] as! String] as? String {
                            view.setValue(val: val )
                        }
                    }
                    self.submitViewdelegate?.submitViewForCell?(submitView: self, cell: view, index: indexPath.row)
                    view.reload()
                    
                }
               
                    
                    
                
                
            default:
                break
            }
            
            cellViews[row["name"] as! String]=cell
            if indexPath.section == params.count - 1 && indexPath.row == params[indexPath.section].count - 1 {
                self.submitViewdelegate?.submitViewDidFinish?(submitView: self)
            }
        }
        cell!.selectionStyle = .none
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.endEditing(false)
        if let params = self.layoutParams{
            let row=params[indexPath.section][indexPath.row]
            if  let cell = cellViews[row["name"] as! String]{

                cell.wilBegin(fn: {

                })
                self.submitViewdelegate?.submitViewDidClick?(submitView: self, cell: cell,index:indexPath)
            }
        }
    }
    
    func clear(){
        cellViews.removeAll()
        self.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    func load() {
        self.clear()
        self.backgroundColor = UIColor.clear
        if let params = self.layoutParams{
            let param = params[0]
            for i in 0..<param.count{
                let row=param[i]
                let v = i==0 ? "V:|-0-[?(60)]" : "V:[\(param[i-1]["name"] as! String)]-2-[?(60)]"
                
                cellViews = self.layoutHelper(name: row["name"] as! String, h: "H:|-0-[?(\(self.frame.width))]-0-|", v: v,views:cellViews ) { (view:UIAOSubmitCellView) in
                    view.reflect(row: row)
                    self.submitViewdelegate?.submitViewForCell?(submitView: self, cell: view, index: i)
                    } as! [String : UIAOSubmitCellView]
            }
        }
        
    }
    
    func getValues()->Dictionary<String,Any>{
        var rs = Dictionary<String,Any>()
        for item in self.cellViews {
            rs[item.key] = item.value.getValue()
        }
        return rs
    }
    
    func setValues(row:[String:AnyObject]){
        for item in self.cellViews {
            if let val = row[item.key]{
                item.value.setValue(val: val as! String)
            }
        }
    }
    
    func append(param:[String:Any],index:IndexPath){
        if var temp = self.layoutParams{
            var items = temp[index.section]
            items.append(param)
            self.layoutParams![index.section] = items
            self.reloadData()
        }
        
    }
    
    func set(name:String,param:[String:Any],index:IndexPath) {
        if var temp = self.layoutParams{
            var items = temp[index.section]
            items[index.row] = param
            self.layoutParams![index.section] = items
            self.reloadData()
        }
    }
    
    func setValue(name:String,textValue:String,value:String){
        if let cell = cellViews[name]{
            cell.setText(val: textValue)
            cell.setValue(val: value)
            cell.reload()
        }
    }
    
    func removeCell(index:IndexPath){
        if var temp = self.layoutParams{
            var items = temp[index.section]
            items.remove(at: index.row)
            self.layoutParams![index.section] = items
            self.reloadData()
        }
    }

}

