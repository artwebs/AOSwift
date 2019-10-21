//
//  NavView.swift
//  HongyuanProperty
//
//  Created by 刘洪彬 on 2019/1/26.
//  Copyright © 2019 liu hongbin. All rights reserved.
//

import UIKit

@objc protocol UIAONavViewDelegate{
    func navViewForParam(navView:UIAONavView)->Array<Array<Dictionary<String,Any>>>;
    @objc optional func navViewForCellHeight(navView:UIAONavView,index:IndexPath)->CGFloat
    @objc optional func navViewForCell(navView:UIAONavView,cell:UIAONavViewCell,index:Int);
}

class UIAONavView: UITableView,UITableViewDelegate,UITableViewDataSource  {
    var navDelegate:UIAONavViewDelegate?
     private var cellViews = Dictionary<String,UIAONavViewCell>()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rs=0;
        if let list = navDelegate?.navViewForParam(navView: self){
            rs = list[section].count;
        }
        return rs;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let params = self.navDelegate?.navViewForParam(navView: self){
            return params.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.navDelegate?.navViewForCellHeight?(navView: self, index: indexPath) ?? CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let params = self.navDelegate?.navViewForParam(navView: self){
            let param = params[indexPath.section]
            let row=param[indexPath.row]
            let delegate = row["delegate"] as! ()->Void
            delegate()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: UIAONavView.className) as? UIAONavViewCell
        if cell == nil{
            cell = UIAONavViewCell(style: .default, reuseIdentifier: UIAONavView.className)
        }
        
        if let params = self.navDelegate?.navViewForParam(navView: self){
            let param = params[indexPath.section]
            let row=param[indexPath.row]
             cell!.views = cell!.layoutHelper(name: "ico", h: "H:|-18-[?(20)]", v: "V:|-15-[?(20)]", views: cell!.views, delegate: { (view:UIImageView) in
                    view.image = UIImage(named: row["ico"] as! String)
                })
            cell!.views = cell!.layoutHelper(name: "arrow", h: "H:[?(7)]-10-|", v: "V:|-18-[?(13)]", views: cell!.views, delegate: { (view:UIImageView) in
                view.image = UIImage(named: "icon_small_right60")
            })
            cell!.views = cell!.layoutHelper(name: "title", h: "H:[ico]-20-[?]-20-[arrow]", v: "V:|-14-[?(22)]", views: cell!.views, delegate: { (view:UILabel) in
                view.font = UIFont.systemFont(ofSize: 16)
                view.text = row["title"] as? String
            })
            
        }
        
        return cell!
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
 
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.dataSource = self
        self.delegate = self
        self.tableFooterView = UIView()
        self.reloadData()
    }

}

class UIAONavViewCell:UITableViewCell{
    var views:Dictionary<String,UIView>=[:]
//    override func draw(_ rect: CGRect) {
//
//    }
}
