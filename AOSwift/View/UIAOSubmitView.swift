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
    func submitViewForParam(submitView:UIAOSubmitView)->Array<Array<Dictionary<String,Any>>>;
    @objc optional func submitViewForValue(submitView:UIAOSubmitView)->[String:AnyObject];
    @objc optional func submitViewForCell(submitView:UIAOSubmitView,cell:UIAOSubmitCellView,index:Int);
    @objc optional func submitViewDidClick(submitView:UIAOSubmitView,cell:UIAOSubmitCellView);
}
class UIAOSubmitView: UITableView,UITableViewDelegate,UITableViewDataSource {
    var submitViewdelegate:UIAOSubmitViewDelegate?
    private var defaultCellHeight:Float32 = 60
    private var cellViews = Dictionary<String,UIAOSubmitCellView>()
    
    override func draw(_ rect: CGRect) {
        self.showsHorizontalScrollIndicator=false
        self.showsVerticalScrollIndicator=false
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        self.delegate = self;
        self.dataSource=self;
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
        if let list = submitViewdelegate?.submitViewForParam(submitView: self){
            rs = list[section].count;
        }
        return rs;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let params = self.submitViewdelegate?.submitViewForParam(submitView: self){
            return params.count
        }
        return 0
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "提交内容"
//    }
//
//    override var numberOfSections: Int{
//        return 1;
//
//    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as UITableViewCell
      
        if let params = self.submitViewdelegate?.submitViewForParam(submitView: self){
            let param = params[indexPath.section]
            let row=param[indexPath.row]
            let v = "V:|-0-[?(40)]"
            switch(row["type"] as! String){
            case "button":
                cellViews = cell.layoutHelper(name: row["name"] as! String, h: "H:|-0-[?(\(self.frame.width))]-0-|", v: v,views:cellViews ) { (view:UIAOSubmitCellViewTextbox) in
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
                    } as! [String : UIAOSubmitCellViewTextbox]
                break
            case "textbox":
                cellViews = cell.layoutHelper(name: row["name"] as! String, h: "H:|-0-[?(\(self.frame.width))]-0-|", v: v,views:cellViews ) { (view:UIAOSubmitCellViewTextbox) in
                    view.reflect(row: row)
                    self.submitViewdelegate?.submitViewForCell?(submitView: self, cell: view, index: indexPath.row)
                    if let values = self.submitViewdelegate?.submitViewForValue?(submitView: self)  {
                        if let val = values[row["name"] as! String]{
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
                    } as! [String : UIAOSubmitCellView]
            case "combobox":
                cellViews = cell.layoutHelper(name: row["name"] as! String, h: "H:|-0-[?(\(self.frame.width))]-0-|", v: v,views:cellViews ) { (view:UIAOSubmitCellViewCombobox) in
                    view.reflect(row: row)
                    self.submitViewdelegate?.submitViewForCell?(submitView: self, cell: view, index: indexPath.row)
                    if let values = self.submitViewdelegate?.submitViewForValue?(submitView: self)  {
                        if let val = values[row["name"] as! String]{
                            view.setValue(val: val )
                        }
                    }
                    } as! [String : UIAOSubmitCellView]
            default:
                break
            }
            
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let params = self.submitViewdelegate?.submitViewForParam(submitView: self){
            let row=params[indexPath.section][indexPath.row]
            if  let cell = cellViews[row["name"] as! String]{
                
                cell.wilBegin(fn: {
                    
                })
                self.submitViewdelegate?.submitViewDidClick?(submitView: self, cell: cell)
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
        if let params = self.submitViewdelegate?.submitViewForParam(submitView: self){
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
            rs[item.key] = item.value.getVlaue()
        }
        return rs
    }
    
    func setValues(row:[String:AnyObject]){
        for item in self.cellViews {
            if let val = row[item.key]{
                item.value.setValue(val: val)
            }
        }
    }
}

class UIAOSubmitCellView:UIView{
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    
    var didFinish:(()->Void)?
    func getVlaue() -> Any? {
        return nil;
    }
    func getName() -> String {
        return ""
    }
    
    func setText(val:String) {
        
    }
    
    func setValue(val:AnyObject){
        
    }
    
    func setLabel(val:String) {
        
    }
    
    func wilBegin(fn:(()->Void)?){
        
    }
    
    func reload(){
        
    }
    
}

class UIAOSubmitCellViewTextbox:UIAOSubmitCellView,UITextFieldDelegate{
    @objc var name:String = ""
    @objc var label:String = ""
    @objc var type:String = "textbox"
    @objc var readOnly:Bool = false
    @objc var display:Bool = true
    @objc var value:String = ""
    @objc var views:Dictionary<String,UIView>=[:]
    
    var edit:UITextField?{
        get{
            return views["textbox"] as? UITextField
        }
    }
    
    override func wilBegin(fn:(()->Void)?){
        self.edit?.becomeFirstResponder()
        fn?()
    }
    
    func getValue() -> String {
        if let val = edit?.text{
            return val
        }else{
            return ""
        }
    }
    
    
    override func setValue(val: AnyObject) {
        self.value = val as? String ?? ""
    }
    
    override func getName() -> String {
        return self.name
    }
    
    override func setText(val: String) {
        self.name = val
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.reload()
    }
    
    override func reload() {
        views = self.layoutHelper(name: "label", h: "H:|-20-[?(100)]", v: "V:|-0-[label(40)]",views:views) { (view:UILabel) in
            view.text = label
            view.textColor = UIColor.black
        }
        views = self.layoutHelper(name: "textbox", h: "H:[label]-0-[?]-10-|", v: "V:|-4-[?(36)]",views:views) { (view:UITextField) in
            view.textAlignment = .right
            view.setValue(12, forKey: "paddingLeft")
            view.setValue(12, forKey: "paddingRight")
            view.delegate = self
            view.text = self.value
            if self.readOnly{
                view.isEnabled = false
            }
            didFinish?()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.value = self.getValue()
        didFinish?()
        return true
    }
}

class UIAOSubmitCellViewCombobox: UIAOSubmitCellView {
    @objc var name:String = ""
    @objc var label:String = ""
    @objc var type:String = "textbox"
    @objc var readOnly:Bool = false
    @objc var display:Bool = true
    @objc var value:String = ""
    @objc var text:String = ""
    @objc var placeHolder:String = ""
    @objc var views:Dictionary<String,UIView>=[:]
    
    func getValue() -> String {
        return self.value
    }
    
    override func setValue(val: AnyObject) {
        if let v = val as? String{
            self.value = v
        }
        
    }
    
    override func getName() -> String {
        return self.name
    }
    
    override func setText(val: String) {
        self.text = val
    }
    
    override func setLabel(val: String) {
        self.label = val
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.reload()
    }
    override func reload() {
        views = self.layoutHelper(name: "label", h: "H:|-20-[?(100)]", v: "V:|-0-[label(40)]",views:views) { (view:UILabel) in
            
            view.text = label
            view.textColor = UIColor.black
            
        }
        
        views = self.layoutHelper(name: "ico", h: "H:[?(7)]-10-|", v: "V:|-15-[?(13)]",views:views) { (view:UIImageView) in
            view.image = UIImage(named: "icon_combobox_ico")
        }
        
        views = self.layoutHelper(name: "button", h: "H:[label]-[?]-[ico]", v: "V:|-0-[?(40)]",views:views) { (view:UILabel) in
            if "".elementsEqual(value){
                view.text = placeHolder
                view.textColor = UIColor.gray
            }else{
                view.text = self.text
                view.textColor = UIColor.black
            }
            
            view.textAlignment = .right
            
            //                {
            //                let rect = self.vController?.view.bounds ?? CGRect.zero
            //                let alertView = UIView(frame: rect)
            //                alertView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            //                let contentView = UIView(frame: CGRect(x: 10, y: 40, width: rect.width-20, height: rect.height-80))
            //                contentView.layer.cornerRadius = 10
            //                contentView.layer.masksToBounds = true
            //                contentView.backgroundColor = UIColor.white
            //                alertView.addSubview(contentView)
            //                self.vController?.view.addSubview(alertView)
            
            //                HttpClient(view: (self.vController?.view)!).get(path: .sysUser_roleName_water_user, params: [:], callback: { (res, data, err) in
            //                    print(data)
            //                })
            
            //            }
            
        }
    }
}

class UIAOSubmitCellViewButton: UIButton {
    
}
