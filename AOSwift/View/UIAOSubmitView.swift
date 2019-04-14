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
    @objc optional func submitViewDidClick(submitView:UIAOSubmitView,cell:UIAOSubmitCellView,index:IndexPath);
    @objc optional func submitViewForCellHeight(submitView:UIAOSubmitView,indexPath: IndexPath)->CGFloat
}
class UIAOSubmitView: UITableView,UITableViewDelegate,UITableViewDataSource {
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
        self.layoutParams = self.submitViewdelegate?.submitViewForParam(submitView: self)
        self.layoutValues = self.submitViewdelegate?.submitViewForValue?(submitView: self)
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
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "提交内容"
//    }
//
//    override var numberOfSections: Int{
//        return 1;
//
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.submitViewdelegate?.submitViewForCellHeight?(submitView: self, indexPath: indexPath){
            return height;
        }else{
            return defaultCellHeight;
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UIAOSubmitCellView?
        if let params = self.layoutParams{
            let param = params[indexPath.section]
            let row=param[indexPath.row]
            switch(row["type"] as! String){
            case "button":
                cell=tableView.dequeueReusableCell(withIdentifier:UIAOSubmitView.className) as? UIAOSubmitCellViewTextbox
                if cell == nil{
                    cell = UIAOSubmitCellViewTextbox(style: .default, reuseIdentifier: UIAOSubmitView.className)
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
            case "textbox": cell=tableView.dequeueReusableCell(withIdentifier:UIAOSubmitView.className) as? UIAOSubmitCellViewTextbox
                if cell == nil{
                    cell = UIAOSubmitCellViewTextbox(style: .default, reuseIdentifier: UIAOSubmitView.className)
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
                }
            case "combobox": cell=tableView.dequeueReusableCell(withIdentifier:UIAOSubmitView.className) as? UIAOSubmitCellViewCombobox
                if cell == nil{
                    cell = UIAOSubmitCellViewCombobox(style: .default, reuseIdentifier: UIAOSubmitView.className)
                }
                if let view = cell as? UIAOSubmitCellViewCombobox{
                    view.reflect(row: row)
                    self.submitViewdelegate?.submitViewForCell?(submitView: self, cell: view, index: indexPath.row)
                    if let values = self.layoutValues  {
                        if let val = values[row["name"] as! String] as? String {
                            view.setValue(val: val )
                        }
                    }
                }
                
            default:
                break
            }
            
            cellViews[row["name"] as! String]=cell
            
        }
        cell!.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
        }
        
    }
}

class UIAOSubmitCellView:UITableViewCell{
    private var _listener = UIListener()
    override  var listener : UIListener{
        get{
            return _listener
        }
    }
    var didFinish:(()->Void)?
    func getValue() -> String {
        return "";
    }
    
    func getName() -> String {
        return ""
    }
    
    func setText(val:String) {
        
    }
    
    func setValue(val:String){
        
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
    @objc var single:Bool = true
    @objc var value:String = ""
    @objc var placeHolder:String = ""
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
    
   override func getValue() -> String {
        if let val = edit?.text{
            return val
        }else{
            return ""
        }
    }
    
    
    override func setValue(val: String) {
        self.value = val
    }
    
    override func getName() -> String {
        return self.name
    }
    
    override func setText(val: String) {
        self.value = val
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.reload()
    }
    
    override func reload() {
        if single{
            views = self.layoutHelper(name: "label", h: "H:|-20-[?(120)]", v: "V:|-0-[label(40)]",views:views) { (view:UILabel) in
                view.text = label
                view.textColor = UIColor.black
            }
            views = self.layoutHelper(name: "textbox", h: "H:[label]-0-[?]-10-|", v: "V:|-4-[?(36)]",views:views) { (view:UITextField) in
                view.textAlignment = .right
                view.setValue(12, forKey: "paddingLeft")
                view.setValue(12, forKey: "paddingRight")
                view.delegate = self
                view.placeholder = placeHolder
                view.text = self.value
                if self.readOnly{
                    view.isEnabled = false
                }else{
                    view.isEnabled = true
                }
                didFinish?()
            }
        }else{
            views = self.layoutHelper(name: "textbox", h: "H:|-10-[?]-10-|", v: "V:|-4-[?(100)]",views:views) { (view:UITextField) in
                view.textAlignment = .left
                view.setValue(12, forKey: "paddingLeft")
                view.setValue(12, forKey: "paddingRight")
                view.delegate = self
                view.placeholder = placeHolder
                view.text = self.value
                if self.readOnly{
                    view.isEnabled = false
                }else{
                    view.isEnabled = true
                }
                didFinish?()
            }
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.value = self.getValue()
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
    @objc var textValue:String = ""
    @objc var placeHolder:String = ""
    @objc var views:Dictionary<String,UIView>=[:]
    
    override func getValue() -> String {
        return self.value
    }
    
    override func setValue(val: String) {
        self.value = val
    }
    
    override func getName() -> String {
        return self.name
    }
    
    override func setText(val: String) {
        self.textValue = val
    }
    
    override func setLabel(val: String) {
        self.label = val
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.reload()
    }
    override func reload() {
        views = self.layoutHelper(name: "label", h: "H:|-20-[?(120)]", v: "V:|-0-[label(40)]",views:views) { (view:UILabel) in
            
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
                view.text = self.textValue
                view.textColor = UIColor.black
            }
            
            view.textAlignment = .right
        }
    }
}

class UIAOSubmitCellViewButton: UIButton {
    
}
